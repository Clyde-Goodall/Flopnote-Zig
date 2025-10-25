const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");
const Pencil = struct {};

pub const Component = struct {
    const Self = @This();
    config: defaults.BaseConfig,
    
    pub fn init(config: defaults.BaseConfig) Self {
        return Self{
            .config = config
        };
    }
    
    pub fn draw(self: *Self) void {
        // const scaled_dimensions = self.config.configStructAsIntegers();
        const padded = self.config.configStructAsIntegers();
        rl.drawRectangle(padded.x, padded.y, padded.width, padded.height, .white);
    }
    
    pub fn update(_: *Self) void {
        return;
    }
};
 