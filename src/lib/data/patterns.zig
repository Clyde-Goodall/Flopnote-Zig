pub const MaskPattern = union(enum) {
    single: [1][1]u1,
    tiny: [2][2]u1,
    small: [3][3]u1,
    medium: [10][10]u1,
    padded_medium: [6][6]u1,
    xl: [10][10]u1,
    xxl: [16][16]u1,

    pub fn getDimensions(self: MaskPattern) usize {
        return switch (self) {
            .single => 1,
            .tiny => 2,
            .small => 3,
            .medium => 5,
            .padded_medium => 6,
            .xl => 10,
            .xxl => 16,
        };
    }

    pub fn getAt(self: MaskPattern, x: usize, y: usize) u1 {
        return switch (self) {
            inline else => |pattern| pattern[y][x],
        };
    }
};

pub const PatternType = enum {
    lightest,
    light,
    vertical,
    horizontal,
    checkered,
    dark,
    darkest,
    point,

    pub fn getPattern(self: PatternType) MaskPattern {
        return switch (self) {
            .lightest => LayerPatterns.lightest,
            .light => LayerPatterns.light,
            .vertical => LayerPatterns.vertical,
            .horizontal => LayerPatterns.horizontal,
            .checkered => LayerPatterns.checkered,
            .dark => LayerPatterns.dark,
            .darkest => LayerPatterns.darkest,
            .point => LayerPatterns.point,
        };
    }
};

pub const LayerPatterns = struct { // patterns that ge tused for building layer masks
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
        [_]u1{ 1, 1 },
        [_]u1{ 0, 0 },
    } };

    pub const dark = MaskPattern{ .tiny = [_][2]u1{
        [_]u1{ 1, 1 },
        [_]u1{ 1, 0 },
    } };

    pub const darkest = MaskPattern{ .small = [_][3]u1{
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 1 },
        [_]u1{ 1, 1, 0 },
    } };

    // pen patterns
    pub const point = MaskPattern{
        .single = [_][1]u1{
            [_]u1{1}, // cmon this is a little funny you gotta admit
        },
    };
};

pub const ToolPatterns = struct { // patterns that actually get used by the tools
    // paint patterns
    pub const lightest = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
    } };

    pub const light = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
    } };

    pub const vertical = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
    } };

    pub const horizontal = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 0, 0, 0, 0, 0, 0 },
    } };

    pub const checkered = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 1, 0, 1, 0, 1 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 1, 0, 1, 0, 1 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 0, 1, 0, 1, 0, 1 },
    } };

    pub const dark = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 0, 1, 0, 1, 0 },
    } };

    pub const darkest = MaskPattern{ .padded_medium = [_][6]u1{
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 1, 0, 1, 1, 0 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 1, 0, 1, 1, 0 },
    } };

    // pen patterns
    pub const solid = MaskPattern{
        .single = [_][1]u1{
            [_]u1{1}, // cmon this is a little funny you gotta admit
        },
    };

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

    pub const spray_light = MaskPattern{ .xl = [_][10]u1{
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

    pub const spray_medium = MaskPattern{ .xxl = [_][16]u1{
        [_]u1{ 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0 },
        [_]u1{ 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0 },
        [_]u1{ 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1 },
        [_]u1{ 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
        [_]u1{ 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0 },
        [_]u1{ 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1 },
        [_]u1{ 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
        [_]u1{ 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1 },
        [_]u1{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0 },
        [_]u1{ 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0 },
        [_]u1{ 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0 },
        [_]u1{ 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0 },
        [_]u1{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0 },
        [_]u1{ 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0 },
    } };
};
