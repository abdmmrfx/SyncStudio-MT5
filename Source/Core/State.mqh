

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

    CChartState();

    void Reset();

    bool SetCursor(
        datetime time,
        double price);

    bool SetScroll(
        int firstBar,
        int visibleBars);

    bool SetScale(
        int scale);

    bool HasChanged() const;

    bool IsDirty(
        EDirtyFlags flag) const;

    void ClearDirty();

    ulong Sequence() const;

    datetime Time() const;

    double Price() const;

    const SyncPacket&
        Packet() const;

private:

    void Touch();

private:

    SyncPacket m_packet;

    uint m_dirtyFlags;
};

