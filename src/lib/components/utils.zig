const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

pub const IntegerRect = struct { x: i32, y: i32, width: i32, height: i32 };

pub fn getPaddedRectDimensions(int_config: defaults.IntegerScaledBaseConfig) IntegerRect {
    return IntegerRect{
        .x = int_config.x + int_config.padding_x,
        .y = int_config.y + int_config.padding_y,
        .width = int_config.width - int_config.padding_x * 2,
        .height = int_config.height - int_config.padding_y * 2,
    };
}

pub fn calculateAspectScaleDimensionsRect(integer_dims: defaults.IntegerScaledBaseConfig, ratio: ?f32) IntegerRect {
    const available_width = integer_dims.width - (2 * integer_dims.padding_x);
    const available_height = integer_dims.height - (2 * integer_dims.padding_y);

    const target_ratio = ratio orelse 0.663; // height/width ratio

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
    const region_x = @as(f32, @floatFromInt(integer_dims.padding_x + integer_dims.x)) + (@as(f32, @floatFromInt(available_width)) - region_width) / 2.0;
    const region_y = @as(f32, @floatFromInt(integer_dims.padding_y + integer_dims.y)) + (@as(f32, @floatFromInt(available_height)) - region_height) / 2.0;

    return utils.IntegerRect{ .x = @as(i32, @intFromFloat(region_x)), .y = @as(i32, @intFromFloat(region_y)), .width = @as(i32, @intFromFloat(region_width)), .height = @as(i32, @intFromFloat(region_height)) };
}

pub fn calcScaledRect(x: i32, y: i32, width: i32, height: i32) IntegerRect {
    const denom: i32 = 100;
    return IntegerRect{ .x = @as(i32, @intFromFloat(defaults.Window.base_config.width * @as(f32, @floatFromInt(@divExact(x, denom))))), .y = @as(i32, @intFromFloat(defaults.Window.base_config.height * @as(f32, @floatFromInt(@divExact(y, denom))))), .width = @as(i32, @intFromFloat(defaults.Window.base_config.width * @as(f32, @floatFromInt(@divExact(width, denom))))), .height = @as(i32, @intFromFloat(defaults.Window.base_config.height * @as(f32, @floatFromInt(@divExact(height, denom))))) };
}

pub fn aspectRatioScaledDimensions(base_rect: rl.Rectangle, target_ratio: f32) rl.Rectangle {
    // Calculate width and height that maintain the target ratio
    const available_width = base_rect.width;
    const available_height = base_rect.height;

    var final_width: f32 = undefined;
    var final_height: f32 = undefined;

    // Fit within available space while maintaining aspect ratio
    if (available_height / available_width > target_ratio) {
        // Container is wider than target ratio, constrain by height
        final_height = available_height;
        final_width = final_height / target_ratio;
    } else {
        // Container is taller than target ratio, constrain by width
        final_width = available_width;
        final_height = final_width * target_ratio;
    }

    return rl.Rectangle{
        .x = base_rect.x + (available_width - final_width) / 2,
        .y = base_rect.y + (available_height - final_height) / 2,
        .width = final_width,
        .height = final_height,
    };
}

pub fn isMouseInRegion(region: *const defaults.IntegerScaledBaseConfig, full_width: ?bool, full_height: ?bool) bool {
    const is_full_width = full_width orelse false;
    const is_full_height = full_height orelse false;

    const width = if (is_full_width)
        rl.getScreenWidth()
    else
        region.x + region.width;

    const height = if (is_full_height)
        rl.getScreenHeight()
    else
        region.y + region.width;

    const mouse = rl.getMousePosition();
    const mx = @as(i32, @intFromFloat(mouse.x));
    const my = @as(i32, @intFromFloat(mouse.y));

    if (mx >= region.x and
        mx <= width and
        my >= region.y and
        my <= height)
    {
        return true;
    }
    return false;
}
