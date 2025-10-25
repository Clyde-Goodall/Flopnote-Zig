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
    visible: bool,
};

pub const PointLayer = struct {
    points: std.array_list.Managed(Point),
    mask_type: MaskType,
    color: rl.Color,
};

pub const Data = struct {
    const Self = @This();
    masks: std.AutoHashMap(MaskType, PointLayer),
    mask: std.array_list.Managed(Point),
    color: rl.Color,

    pub fn init(allocator: std.mem.Allocator, mask_type: MaskType) !Self {
        const mask = try Data.buildLayerPoints(allocator);

        return Self{
            .mask_type = mask_type,
            .mask = mask,
        };
    }

    // this should build out the patter for each potential pattern, repeating horizontally and vertically for the entire canvas
    fn buildLayerPoints(allocator: std.mem.Allocator, color: ?rl.Color) !std.AutoHashMap(MaskType, PointLayer) {
        const width = @as(usize, @intFromFloat(defaults.Canvas.base_config.width / 5));
        const height = @as(usize, @intFromFloat(defaults.Canvas.base_config.height / 5));
        const layer_map = std.AutoHashMap(patterns.MaskPattern, PointLayer);
        for (std.enums.values(patterns.MaskPattern)) |pattern| {
            var points = std.array_list.Managed(Point).init(allocator);
            try points.ensureTotalCapacity(width * height);
            for (0..(width - 1)) |x| {
                for (0..(height - 1)) |y| {
                    const dims = pattern.getDimensions();
                    const pattern_loc = rl.Vector2{
                        .x = x % dims,
                        .y = y % dims,
                    };

                    try points.append(Point{
                        .x = @as(i32, @intCast(pattern_loc.x)),
                        .y = @as(i32, @intCast(pattern_loc.y)),
                        .visible = false,
                    });
                }
            }
            layer_map.put(pattern, PointLayer{
                .points = points,
                .mask_type = pattern,
                .color = color orelse rl.Color.black
            });
        }
        return layer_map;
    }
};

fn updatePatternLocation(location: *rl.Vector2, pattern: Mask) void {}
