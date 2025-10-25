const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

pub const IntegerRect = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32
};

pub fn getPaddedRectDimensions(int_config: defaults.IntegerScaledBaseConfig) IntegerRect {
    return IntegerRect {
        .x = int_config.x + int_config.padding_x,
        .y = int_config.y + int_config.padding_y,
        .width = int_config.width - int_config.padding_x * 2,
        .height = int_config.height - int_config.padding_y * 2,
    };
}


pub fn calculateAspectScaleDimensionsRect(integer_dims: defaults.IntegerScaledBaseConfig, ratio: ?f32) IntegerRect {
        
        const available_width = integer_dims.width - (2 * integer_dims.padding_x);
        const available_height = integer_dims.height - (2 * integer_dims.padding_y);
        
        const target_ratio = ratio orelse 0.75; // height/width ratio
        
        var region_width: f32 = 0;
        var region_height: f32 = 0;
        
        // Calculate container aspect ratio
        const container_ratio = @as(f32, @floatFromInt(available_height)) / @as(f32, @floatFromInt(available_width));
        
        if (container_ratio > target_ratio) {
            // Container is taller than target - width is the limiting factor
            region_width = @as(f32, @floatFromInt(available_width));
            region_height = region_width * target_ratio;
        } else {
            // Container is wider than target - height is the limiting factor
            region_height = @as(f32, @floatFromInt(available_height));
            region_width = region_height / target_ratio;
        }
        
        // Center the region in available space
        const region_x =  @as(f32, @floatFromInt(integer_dims.padding_x + integer_dims.x)) + (@as(f32, @floatFromInt(available_width)) - region_width) / 2.0;
        const region_y = @as(f32, @floatFromInt(integer_dims.padding_y + integer_dims.y)) + (@as(f32, @floatFromInt(available_height)) - region_height) / 2.0;

    return utils.IntegerRect{
        .x = @as(i32, @intFromFloat(region_x)),
        .y =  @as(i32, @intFromFloat(region_y)),
        .width =  @as(i32, @intFromFloat(region_width)),
        .height =  @as(i32, @intFromFloat(region_height))
    };
}

pub fn calcScaledRect(x: i32, y: i32, width: i32, height: i32) IntegerRect {
    const denom: i32 = 100;
    return IntegerRect {
        .x = @as(i32, @intFromFloat(defaults.Window.base_config.width * @as(f32, @floatFromInt(@divExact(x, denom))))),
        .y = @as(i32, @intFromFloat(defaults.Window.base_config.height * @as(f32, @floatFromInt(@divExact(y, denom))))),
        .width = @as(i32, @intFromFloat(defaults.Window.base_config.width * @as(f32, @floatFromInt(@divExact(width, denom))))),
        .height = @as(i32, @intFromFloat(defaults.Window.base_config.height * @as(f32, @floatFromInt(@divExact(height, denom)))))
    };
}