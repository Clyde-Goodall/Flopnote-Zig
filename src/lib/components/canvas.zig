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
            // const canvas_container = self.config.configStructAsIntegers();
            // rl.drawRectangle(canvas_container.x, canvas_container.y, canvas_container.width, canvas_container.height, .gray);

            rl.drawRectangle(region.x, region.y, region.width, region.height, .white);
        }
    }

    fn updateDrawableRegion(self: *Self) void {
        const scaled_dims = defaults.Canvas.base_config.configStructAsIntegers();
        const drawable_width = defaults.Canvas.TARGET_PIXEL_WIDTH * defaults.Canvas.SCALE_MULTIPLIER;
        const drawable_height = defaults.Canvas.TARGET_PIXEL_HEIGHT * defaults.Canvas.SCALE_MULTIPLIER;
        const canvas_horizontal_midpoint = drawable_width / 2;
        const canvas_vertical_midpoint = drawable_height / 2;
        // const drawable_horizontal_midpoint = @divExact((scaled_dims.width * defaults.Canvas.SCALE_MULTIPLIER), 2);
        // const drawable_vertical_midpoint = @divExact((scaled_dims.height * defaults.Canvas.SCALE_MULTIPLIER), 2);

        const drawable_region_x: i32 = @divExact(scaled_dims.width, 2) - canvas_horizontal_midpoint + scaled_dims.x;
        const drawable_region_y: i32 = @divExact(scaled_dims.height, 2) - canvas_vertical_midpoint + scaled_dims.y;
        self.drawable_region = utils.IntegerRect{
            .x = drawable_region_x,
            .y = drawable_region_y,
            .width = drawable_width,
            .height = drawable_height,
        };
    }

    pub fn update(_: *Self) void {
        return;
    }

    pub fn setActiveFrame(self: *Self, open_frame: *frame.Data) void {
        self.open_frame = open_frame;
    }
};
