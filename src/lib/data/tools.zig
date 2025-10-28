pub const ToolType = enum { Pencil, Fill, Paint, Eraser, Select };

// correlates to the available brush options in the selection menu on the DSi
pub const ToolSize = enum {
    A, // single point
    B, // 2x2
    C, // 3x3
    D, // pseudo pressure brush 3x3 at its max. The longer the lerp period, the thinner the line?
    E, // hollow center, 3 tall
    F, // light spray
    G, // medium spray
    H, // heavy spray
    I, // 5x5
    J, // 7x7
    K, // 9x9
    L, // pseudo pressure brush 4x4 at its max
    M, // hollow diamond 7x7
    N, // wider light spray
    O, // wider medium spray
    P, // larger heavy spray
};
