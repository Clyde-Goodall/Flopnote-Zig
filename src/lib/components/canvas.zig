const std = @import("std");

const rl = @import("raylib");

const frame = @import("../data/frame.zig");
const defaults = @import("../defaults.zig");
const utils = @import("utils.zig");

pub const Component = struct {
    const Self = @This();

    open_frame: ?*frame.Data,
    config: defaults.BaseConfig,
    drawable_region: ?utils.IntegerRect,

    pub fn init(base_config: defaults.BaseConfig, open_frame: ?*frame.Data) Component {
        var component = Component{
            .config = base_config,
            .open_frame = open_frame orelse null,
            .drawable_region = null,
        };
        component.updateDrawableRegion();
        return component;
    }

    pub fn resize() void {
        return;
    }

    pub fn draw(self: *Self) void {
        if (self.drawable_region) |region| {
            rl.drawRectangle(region.x, region.y, region.width, region.height, .white);
        }
    }

    fn updateDrawableRegion(self: *Self) void {
        const scaled_dims = defaults.Canvas.base_config.configStructAsIntegers();
        const canvas_horizontal_midpoint = defaults.Canvas.TARGET_PIXEL_WIDTH / 2;
        const canvas_vertical_midpoint = defaults.Canvas.TARGET_PIXEL_HEIGHT / 2;
        const drawable_horizontal_midpoint = @divExact((scaled_dims.width * defaults.Canvas.SCALE_MULTIPLIER), 2);
        const drawable_vertical_midpoint = @divExact((scaled_dims.height * defaults.Canvas.SCALE_MULTIPLIER), 2);

        const drawable_region_x: i32 = scaled_dims.x + drawable_horizontal_midpoint - canvas_horizontal_midpoint;
        const drawable_region_y: i32 = scaled_dims.y + drawable_vertical_midpoint - canvas_vertical_midpoint;
        self.drawable_region = utils.IntegerRect{
            .x = drawable_region_x,
            .y = drawable_region_y,
            .width = defaults.Canvas.TARGET_PIXEL_WIDTH,
            .height = defaults.Canvas.TARGET_PIXEL_HEIGHT,
        };
    }

    pub fn update(_: *Self) void {
        return;
    }

    pub fn setActiveFrame(self: *Self, open_frame: *frame.Data) void {
        self.open_frame = open_frame;
    }
};
