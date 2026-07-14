//+------------------------------------------------------------------+
//| ChartSyncEA.mq5                                                  |
//| Version : 0.1.0                                                  |
//| Core framework (EA version)                                      |
//| Author  : AbdM + ChatGPT                                         |
//+------------------------------------------------------------------+
#property strict
#property version "0.1"

enum ENUM_ROLE
{
   ROLE_MASTER=0,
   ROLE_SLAVE=1,
   ROLE_PEER=2
};

struct ChartState
{
   ulong    seq;
   long     source;
   datetime t;
   double   price;
   int      firstBar;
   int      visibleBars;
   int      scale;
   bool     visible;
};

input string SyncGroup="Default";
input ENUM_ROLE Role=ROLE_PEER;
input color MarkerColor=clrLime;
input ENUM_LINE_STYLE MarkerStyle=STYLE_DOT;
input int MarkerWidth=1;
input int TimerMS=20;

ChartState LocalState;
ulong LastRemoteSeq=0;
string NS;

bool CanBroadcast(){ return Role==ROLE_MASTER || Role==ROLE_PEER; }
bool CanReceive(){ return Role==ROLE_SLAVE || Role==ROLE_PEER; }
string GV(const string n){ return NS+n; }

void MarkerCreate()
{
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);

   if(ObjectFind(0,"CS_VLINE")<0)
      ObjectCreate(0,"CS_VLINE",OBJ_VLINE,0,TimeCurrent(),0);

   if(ObjectFind(0,"CS_HLINE")<0)
      ObjectCreate(0,"CS_HLINE",OBJ_HLINE,0,0,bid);

   ObjectSetInteger(0,"CS_VLINE",OBJPROP_COLOR,MarkerColor);
   ObjectSetInteger(0,"CS_VLINE",OBJPROP_STYLE,MarkerStyle);
   ObjectSetInteger(0,"CS_VLINE",OBJPROP_WIDTH,MarkerWidth);

   ObjectSetInteger(0,"CS_HLINE",OBJPROP_COLOR,MarkerColor);
   ObjectSetInteger(0,"CS_HLINE",OBJPROP_STYLE,MarkerStyle);
   ObjectSetInteger(0,"CS_HLINE",OBJPROP_WIDTH,MarkerWidth);
}

void MarkerUpdate(const ChartState &s)
{
   MarkerCreate();
   ObjectSetInteger(0,"CS_VLINE",OBJPROP_TIME,s.t);
   ObjectSetDouble(0,"CS_HLINE",OBJPROP_PRICE,s.price);
}

void MarkerDestroy()
{
   ObjectDelete(0,"CS_VLINE");
   ObjectDelete(0,"CS_HLINE");
}

void SendState()
{
   GlobalVariableSet(GV("TIME"),(double)LocalState.t);
   GlobalVariableSet(GV("PRICE"),LocalState.price);
   GlobalVariableSet(GV("SOURCE"),(double)LocalState.source);
   GlobalVariableSet(GV("SEQ"),(double)LocalState.seq);
}

bool ReceiveState(ChartState &s)
{
   if(!GlobalVariableCheck(GV("SEQ"))) return false;

   s.seq=(ulong)GlobalVariableGet(GV("SEQ"));
   if(s.seq==LastRemoteSeq) return false;

   s.t=(datetime)GlobalVariableGet(GV("TIME"));
   s.price=GlobalVariableGet(GV("PRICE"));
   s.source=(long)GlobalVariableGet(GV("SOURCE"));

   if(s.source==ChartID())
   {
      LastRemoteSeq=s.seq;
      return false;
   }

   LastRemoteSeq=s.seq;
   return true;
}

int OnInit()
{
   NS="CS_"+SyncGroup+"_";
   MarkerCreate();
   EventSetMillisecondTimer(TimerMS);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   MarkerDestroy();
}

void OnTimer()
{
   if(!CanReceive()) return;

   ChartState remote;
   if(ReceiveState(remote))
      MarkerUpdate(remote);
}

void OnChartEvent(const int id,const long &l,const double &d,const string &s)
{
   if(id!=CHARTEVENT_MOUSE_MOVE) return;
   if(!CanBroadcast()) return;

   datetime t;
   double price;
   int win=0;

   if(!ChartXYToTimePrice(0,(int)l,(int)d,win,t,price))
      return;

   if(t==LocalState.t && price==LocalState.price)
      return;

   LocalState.seq++;
   LocalState.source=ChartID();
   LocalState.t=t;
   LocalState.price=price;

   MarkerUpdate(LocalState);
   SendState();
}
