const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const std = @import("std");
pub const Component = struct {
    const Self = @This();
    config: defaults.BaseConfig,
    
    pub fn init(base_config: defaults.BaseConfig) Component {
        const as_ints = base_config.configStructAsIntegers();
        std.debug.print("{} dimensions: {},{},{},{}", .{base_config.container_name, as_ints.x, as_ints.y, as_ints.width, as_ints.height});
        return Component{};
    }
    
    pub fn draw(self: *Self) !void {
        const scaled_dimensions = self.config.configStructAsIntegers();
        const padded_width = scaled_dimensions.width - scaled_dimensions.padding_x;
        const padded_height = scaled_dimensions.height - scaled_dimensions.padding_y;

        rl.drawRectangle(scaled_dimensions.x, scaled_dimensions.y, padded_width, padded_height, .white);
    }
    
    pub fn update(_: *Self) void {
        return;
    }
};
