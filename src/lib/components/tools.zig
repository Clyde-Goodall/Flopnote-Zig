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

    pub fn draw(self: *Self) !void {
        const dims = self.config.configStructAsIntegers();
        rl.drawRectangle(
            dims.x + dims.padding_x - 1,
            dims.y + dims.padding_y - 1,
            dims.width - (dims.padding_x * 2) + 2,
            dims.height - (dims.padding_y * 2) + 2,
            self.theme_data.HIGHLIGHT_SECONDARY,
        );
        rl.drawRectangle(
            dims.x + dims.padding_x,
            dims.y + dims.padding_y,
            dims.width - (dims.padding_x * 2),
            dims.height - (dims.padding_y * 2),
            self.theme_data.PRIMARY,
        );
    }

    pub fn update(_: *Self) void {
        return;
    }
};
