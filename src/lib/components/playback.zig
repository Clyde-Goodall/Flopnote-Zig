const frame = @import("../data/frame.zig");
const defaults = @import("../defaults.zig");
const rl = @import("raylib");

pub const Component = struct {
    const Self = @This();

    open_frame: ?*frame.Data,
    config: defaults.BaseConfig,

    pub fn init(_: *Self, base_config: defaults.BaseConfig) Component {
        return Component{
            .config = base_config.config,
        };
    }

    pub fn draw(self: *Self) void {
        const scaled_dimensions = self.config.configStructAsIntegers();
        rl.drawRectangle(scaled_dimensions.x, scaled_dimensions.y, scaled_dimensions.width, scaled_dimensions.height, .white);    }
    
    pub fn update(_: *Self) void {
        return;
    }
};
