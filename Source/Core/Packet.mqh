#pragma once

struct SyncPacket
{
    uint      Version;
    ulong     Sequence;

    long      SourceChart;

    datetime  CursorTime;
    double    CursorPrice;

    int       FirstVisibleBar;
    int       VisibleBars;
    int       ChartScale;

    uint      Flags;
};
