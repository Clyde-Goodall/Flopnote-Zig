pub const MaskPattern = union(enum) {
    single: [1][1]u1,
    tiny: [2][2]u1,
    small: [3][3]u1,
    medium: [10][10]u1,
    large: [16][16]u1,

    pub fn getDimensions(self: MaskPattern) usize {
        return switch (self) {
            .single => 1,
            .tiny => 2,
            .small => 3,
            .medium => 10,
            .large => 16,
        };
    }

    pub fn getAt(self: MaskPattern, x: usize, y: usize) u1 {
        return switch (self) {
            inline else => |pattern| pattern[y][x],
        };
    }
};

pub const Patterns = struct {
    // paint patterns
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

    pub const solid = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 1 },
        [_]u1{ 1, 1 },
    } };

    // pen patterns
    pub const point = MaskPattern{ .single = [_][1]u1{[_]u1{1}} };

    pub const two = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 1 },
        [_]u1{ 1, 1 },
    } };

    pub const three = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
    } };

    pub const pressure_small = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
    } };

    pub const hollow_horizontal = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 1, 1 },
        [_]u1{ 0, 0, 0 },
        [_]u1{ 1, 1, 1 },
    } };

    pub const spray_light = MaskPattern{ .medium = [_][10]u1{
        [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        [_]u1{ 0, 0, 0, 1, 0, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 1 },
        [_]u1{ 0, 1, 0, 1, 0, 0, 0, 0, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
        [_]u1{ 0, 0, 1, 0, 1, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 1 },
        [_]u1{ 0, 0, 0, 1, 0, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    } };
};
