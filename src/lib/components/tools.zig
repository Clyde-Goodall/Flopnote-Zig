const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");
const workspace = @import("../data/workspace.zig");

pub const Component = struct {
    const Self = @This();
    config: defaults.BaseConfig,
    wkspace: *const workspace.Data,
    theme_data: defaults.Theme,

    pub fn init(wkspace: *const workspace.Data) Self {
        return Self{
            .config = defaults.Tools.base_config,
            .wkspace = wkspace,
            .theme_data = defaults.Theme.init(),
        };
    }

    pub fn draw(self: *Self) void {
        const padded = self.config.configStructAsIntegers();
        rl.drawRectangle(
            padded.x,
            padded.y,
            padded.width,
            padded.height,
            self.theme_data.PRIMARY,
        );
    }

    pub fn update(_: *Self) void {
        return;
    }
};
