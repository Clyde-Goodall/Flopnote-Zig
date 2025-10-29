const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const std = @import("std");
const workspace = @import("../data/workspace.zig");

pub const Component = struct {
    const Self = @This();
    wkspace: *const workspace.Data,
    config: defaults.BaseConfig,
    theme_data: defaults.Theme,

    pub fn init(wkspace: *const workspace.Data) Component {
        return Component{
            .config = defaults.SpeedControl.base_config,
            .wkspace = wkspace,
            .theme_data = defaults.Theme.init(),
        };
    }

    pub fn draw(self: *Self) void {
        const scaled_dims = self.config.configStructAsIntegers();

        rl.drawRectangle(
            scaled_dims.x,
            scaled_dims.y,
            scaled_dims.width,
            scaled_dims.height,
            self.theme_data.HIGHLIGHT,
        );
        rl.drawRectangle(
            scaled_dims.x + 1,
            scaled_dims.y + 1,
            scaled_dims.width - 2,
            scaled_dims.height - 2,
            self.theme_data.PRIMARY,
        );
    }

    pub fn update(_: *Self) void {
        return;
    }
};
