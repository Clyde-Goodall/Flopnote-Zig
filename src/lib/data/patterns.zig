pub const MaskPattern = union(enum) {
    tiny: [2][2]u1,
    small: [3][3]u1,

    pub fn getDimensions(self: MaskPattern) usize {
        return switch (self) {
            .tiny => 2,
            .small => 3,
        };
    }

    pub fn getAt(self: MaskPattern, x: usize, y: usize) u1 {
        return switch (self) {
            inline else => |pattern| pattern[y][x],
        };
    }
};

pub const Patterns = struct {
    pub const lightest = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 0, 0 },
        [_]u1{ 0, 0, 0 },
        [_]u1{ 0, 0, 0 },
    } };

    pub const light = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 0 },
        [_]u1{ 0, 0 },
    } };

    pub const vertical = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 0 },
        [_]u1{ 1, 0 },
    } };

    pub const horizontal = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 1 },
        [_]u1{ 0, 0 },
    } };

    pub const checkered = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 0 },
        [_]u1{ 0, 1 },
    } };

    pub const dark = MaskPattern{ .small = [_][2]u1{
        [_]u1{ 1, 1 },
        [_]u1{ 1, 0 },
    } };

    pub const darkest = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 0 },
    } };
};
