const std = @import("std");

const rl = @import("raylib");

const frame = @import("../data/frame.zig");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

pub const Component = struct {
    const Self = @This();

    open_frame: ?*frame.Data,
    config: defaults.BaseConfig,
    region: ?utils.IntegerRect,

    pub fn init(base_config: defaults.BaseConfig, open_frame: ?*frame.Data) Component {
        var component = Component{ .config = base_config, .open_frame = open_frame orelse null, .region = null };
        component.updateAspectDimensions();
        return component;
    }

    pub fn resize() void {
        return;
    }

    pub fn draw(self: *Self) void {
        if (self.region) |region| {
            rl.drawRectangle(region.x, region.y, region.width, region.height, .white);
        }
    }

    fn updateAspectDimensions(self: *Self) void {
        self.region = utils.calculateAspectScaleDimensionsRect(
            self.config.configStructAsIntegers(),
            self.config.ratio,
        );
    }

    pub fn update(_: *Self) void {
        return;
    }

    pub fn setActiveFrame(self: *Self, open_frame: *frame.Data) void {
        self.open_frame = open_frame;
    }
};
