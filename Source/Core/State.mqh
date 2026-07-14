private:

    SyncPacket m_packet;

    uint m_dirtyFlags;

//==================================================================
// CChartState
//
// Owns the authoritative synchronization state for one chart.
//
// Responsibilities:
// - Maintain packet data
// - Track dirty flags
// - Increment sequence on state changes
// - Provide immutable packet access
//
// Does NOT:
// - Draw objects
// - Communicate between charts
// - Access MT5 APIs
//==================================================================

class CChartState
{
public:

    bool Init();

    void Reset();

    bool SetCursor(
        datetime time,
        double price);

    bool SetScroll(
        int firstBar,
        int visibleBars);

    bool SetScale(
        int scale);

    void Touch();

    bool IsDirty() const;

    bool IsDirty(uint flag) const;

    void ClearDirty();

    const SyncPacket& Packet() const;
};

enum EDirtyFlags
{
    DIRTY_NONE    = 0,

    DIRTY_CURSOR  = 1 << 0,

    DIRTY_SCROLL  = 1 << 1,

    DIRTY_SCALE   = 1 << 2,

    DIRTY_RENDER  = 1 << 3
};

