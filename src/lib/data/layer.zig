const std = @import("std");
const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const patterns = @import("patterns.zig");

pub const MaskType = enum {
    PatternLightest,
    PatternLight,
    PatternVertical,
    PatternHorizontal,
    PatternCheckered,
    PatternDark,
    PatternDarkest,
    Solid,
};

pub const Point = struct {
    x: i32,
    y: i32,
    value: u1,
    visible: bool,
};

pub const PointLayer = struct {
    points: std.array_list.Managed(Point),
    mask_type: patterns.PatternType,
    color: rl.Color,
};

pub const Data = struct {
    const Self = @This();
    masks: std.AutoHashMap(patterns.PatternType, PointLayer),
    color: rl.Color,

    pub fn init(allocator: std.mem.Allocator, color: ?rl.Color) !Self {
        const layer_color = color orelse rl.Color.black;
        const masks = try Data.buildLayerPoints(allocator, layer_color);

        return Self{
            .masks = masks,
            .color = layer_color,
        };
    }

    // this should build out the patter for each potential pattern,
    fn buildLayerPoints(allocator: std.mem.Allocator, color: ?rl.Color) !std.AutoHashMap(patterns.PatternType, PointLayer) {
        const width = @as(usize, @intFromFloat(defaults.Canvas.base_config.width / 5));
        const height = @as(usize, @intFromFloat(defaults.Canvas.base_config.height / 5));
        var layer_map = std.AutoHashMap(patterns.PatternType, PointLayer).init(allocator);

        // iterate over all pattern types
        inline for (@typeInfo(patterns.PatternType).@"enum".fields) |field| {
            const pattern_type: patterns.PatternType = @enumFromInt(field.value);
            const pattern = pattern_type.getPattern();

            var points = std.array_list.Managed(Point).init(allocator);
            try points.ensureTotalCapacity(width * height);
            for (0..(width - 1)) |x| {
                for (0..(height - 1)) |y| {
                    const dims = pattern.getDimensions();
                    const pattern_x = x % dims;
                    const pattern_y = y % dims;
                    try points.append(Point{
                        .x = @as(i32, @intCast(x)),
                        .y = @as(i32, @intCast(y)),
                        .value = pattern.getAt(pattern_x, pattern_y),
                        .visible = false,
                    });
                }
            }

            try layer_map.put(pattern_type, PointLayer{
                .points = points,
                .mask_type = pattern_type,
                .color = color orelse rl.Color.black,
            });
        }
        return layer_map;
    }
};
