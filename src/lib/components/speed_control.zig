const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const std = @import("std");
const workspace = @import("../data/workspace.zig");

pub const Arrow = struct {
    config: defaults.BaseConfig,
    active: bool,

    pub fn init() void {}
};

pub const Component = struct {
    const Self = @This();
    wkspace: *const workspace.Data,
    // fps_scale: [7]i8,
    config: defaults.BaseConfig,
    theme_data: defaults.Theme,
    text_sizing: i8,

    pub fn init(wkspace: *const workspace.Data) Component {
        return Component{
            .config = defaults.SpeedControl.base_config,
            .wkspace = wkspace,
            .theme_data = defaults.Theme.init(),
            .text_sizing = 15,
        };
    }

    pub fn draw(self: *Self) !void {
        self.drawBackground();
        try self.drawSpeedText();
        // self.drawArrows();
    }

    fn drawBackground(self: *Self) void {
        const scaled_dims = self.config.configStructAsIntegers();

        rl.drawRectangle(
            scaled_dims.x,
            scaled_dims.y,
            scaled_dims.width,
            scaled_dims.height,
            self.theme_data.HIGHLIGHT_SECONDARY,
        );
        rl.drawRectangle(
            scaled_dims.x + 1,
            scaled_dims.y + 1,
            scaled_dims.width - 2,
            scaled_dims.height - 2,
            self.theme_data.PRIMARY,
        );
    }

    fn drawArrows(self: *Self) void {
        var i: usize = 0;
        while (i < self.fps_scale.len) : (i += 1) {
            self.drawArrow(i);
        }
    }

    // fn drawArrow(self: *Self, idx: usize) void {

    // }

    fn drawSpeedText(self: *Self) !void { // this will only ever show between 1 and 8, inclusive
        std.debug.print("drawSpeedText called\n", .{});
        if (self.wkspace.*.active_project == null) {
            std.debug.print("active_project is null!\n", .{});
            return;
        }
        const cfg = self.config.configStructAsIntegers();
        var buf: [6]u8 = undefined;
        std.debug.print("playback speed: {}\n", .{self.wkspace.*.active_project.?.playback_speed});
        const text = try std.fmt.bufPrintZ(&buf, "{}", .{self.wkspace.*.active_project.?.playback_speed});
        const anchor_x = cfg.x + 10;
        const anchor_y = cfg.y + 5;
        rl.drawText(text, anchor_x, anchor_y, 22, self.theme_data.HIGHLIGHT_SECONDARY);
    }

    pub fn update(_: *Self) void {
        return;
    }

    // pub fn buildArrowArray(self: *Self) std.array_list.Managed(Arrow) {

    // }
};
