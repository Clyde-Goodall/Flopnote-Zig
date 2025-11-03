const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");
const workspace = @import("../data/workspace.zig");
const theme_data = defaults.Theme;

pub const Component = struct {
    const Self = @This();
    config: defaults.BaseConfig,
    wkspace: *const workspace.Data,

    pub fn init(wkspace: *const workspace.Data) Self {
        return Self{
            .config = defaults.Tools.base_config,
            .wkspace = wkspace,
        };
    }

    pub fn draw(self: *Self) !void {
        const dims = self.config.configStructAsIntegers();
        utils.drawBorderedComponentRect(
            dims,
            theme_data.HIGHLIGHT_SELECTED,
            theme_data.PRIMARY,
            2,
            true,
        );
    }

    pub fn update(_: *Self) void {
        return;
    }
};
