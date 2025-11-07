const rl = @import("raylib");
const tools_data = @import("data/tools.zig");
const canvas = @import("components/canvas.zig");
const menu = @import("components/menu.zig");
const playback = @import("components/playback.zig");
const patterns = @import("data/patterns.zig");
const timeline = @import("components/timeline.zig");
const tools = @import("components/tools.zig");
const std = @import("std");

pub const StickyAnchor = enum {
    TopLeft,
    TopRight,
    TopCenter,
    BottomLeft,
    BottomRight,
    BottomCenter,
    Center,
    None,
};

// All defaults to be used for building the UI and sizing, theming, etc.
pub const Window = struct {
    pub const WIDTH = 1000;
    pub const HEIGHT = 600;
};

pub const Theme = struct {
    // UI-specific
    pub const PRIMARY = rl.Color.white;
    pub const SECONDARY = rl.Color.orange;
    pub const ACCENT = rl.Color.yellow;
    pub const TEXT_PRIMARY = rl.Color.black;
    pub const TEXT_SECONDARY = rl.Color.white;
    pub const HIGHLIGHT = rl.Color.init(251, 96, 0, 255);
    pub const HIGHLIGHT_SECONDARY = rl.Color.init(255, 200, 122, 255);
    pub const HIGHLIGHT_SELECTED = rl.Color.init(249, 156, 80, 255);
    pub const BACKGROUND_SOLID = rl.Color.init(190, 190, 190, 255);
    pub const BACKGROUND_GRID_LINES = rl.Color.init(140, 140, 140, 255);
    pub const DISABLED = rl.Color.gray;

    // canvas-specific
    pub const CANVAS_BLUE = rl.Color.init(48, 0, 251, 255);
    pub const CANVAS_RED = rl.Color.init(251, 0, 48, 255);
};

pub const ScaleMode = enum {
    window_proportional,
    aspect_preserving,
};

pub const IntegerScaledBaseConfig = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    max_width: i32,
    max_height: i32,
    padding_x: i32,
    padding_y: i32,
    border_radius: ?i32,
};

// Sizing is based on propertions/percent rather than fixed integer values
// This includes padding and border radius
// Should be used for UI only
pub const BaseConfig = struct {
    const Self = @This();

    container_name: []const u8,
    maintain_aspect: ?bool,
    x: f32, // Should be an integer beteen 0-100, 1 being 1%, 50 being 50%, etc
    y: f32,
    width: f32,
    height: f32,
    max_width: f32,
    max_height: f32,
    padding_x: f32,
    padding_y: f32,
    ratio: ?f32, // x to y ratio, i.e. for maintaining canvas aspect on window size change
    sticky: bool,
    sticky_anchor: ?StickyAnchor,
    scale: bool,
    resizeable: bool,
    border_radius: ?f32,

    pub fn configStructAsIntegers(self: *const Self) IntegerScaledBaseConfig {
        const origin = self.multiplyProportionByActualSize(.{
            .x = self.x,
            .y = self.y,
        });
        const dimensions = self.multiplyProportionByActualSize(.{
            .x = self.width,
            .y = self.height,
        });
        const max_dimensions = self.multiplyProportionByActualSize(.{
            .x = self.max_width,
            .y = self.max_height,
        });
        const padding = self.multiplyProportionByActualSize(.{
            .x = self.padding_x,
            .y = self.padding_y,
        });
        return IntegerScaledBaseConfig{
            .x = @as(i32, @intFromFloat(origin.x)),
            .y = @as(i32, @intFromFloat(origin.y)),
            .width = @as(i32, @intFromFloat(dimensions.x)),
            .height = @as(i32, @intFromFloat(dimensions.y)),
            .max_width = @as(i32, @intFromFloat(max_dimensions.x)),
            .max_height = @as(i32, @intFromFloat(max_dimensions.y)),
            .padding_x = @as(i32, @intFromFloat(padding.x)),
            .padding_y = @as(i32, @intFromFloat(padding.y)),
            .border_radius = @as(i32, @intFromFloat(self.border_radius orelse 0)) * 100,
        };
    }

    fn multiplyProportionByActualSize(
        self: *const Self,
        coord_pair: rl.Vector2,
    ) rl.Vector2 {
        // const pixels_per_percent = Window.HEIGHT / 100.0;
        if (self.maintain_aspect orelse false) {
            return rl.Vector2{
                .x = Window.HEIGHT * coord_pair.x / 100,
                .y = Window.HEIGHT * coord_pair.y / 100,
            };
        } else {
            return rl.Vector2{
                .x = Window.WIDTH * coord_pair.x / 100,
                .y = Window.HEIGHT * coord_pair.y / 100,
            };
        }
    }
};



pub const CanvasColors = enum(rl.Color) {
    Black = rl.Color.black,
    White = rl.Color.white,
    Blue = rl.Color.init(48, 0, 251, 255),
    Red = rl.Color.init(251, 0, 48, 255),
};

pub const Tools = struct {
    pub const STARTING_FRAME_SPEED = 3;
    const X = 0;
    const Y = 0;
    const WIDTH = 20;
    const HEIGHT = 80;
    const MAX_WIDTH = WIDTH;
    const MAX_HEIGHT = HEIGHT;
    pub const SELECTED_TOOL = tools.ToolType.Pencil;
    pub const SELECTED_TOOL_SIZE = tools.ToolSize.Medium;

    pub const base_config = BaseConfig{
        .container_name = "Tools",
        .maintain_aspect = false,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = MAX_WIDTH,
        .max_height = MAX_HEIGHT,
        .padding_x = 1,
        .padding_y = 1.5,
        .ratio = null,
        .sticky = false,
        .scale = false,
        .resizeable = false,
        .border_radius = 10,
        .sticky_anchor = .TopLeft,
    };
};

pub const Canvas = struct {
    const X = Tools.X + Tools.WIDTH;
    const Y = 0;
    const WIDTH = 80;
    const HEIGHT = 80;
    const MAX_WIDTH = WIDTH;
    const MAX_HEIGHT = HEIGHT;
    pub const TARGET_PIXEL_WIDTH: i32 = 190;
    pub const TARGET_PIXEL_HEIGHT: i32 = 126;
    // technically, those dimensions are scaled to 2x,
    // so the actual tools are 2x2px rather than 1x1.
    pub const GRID_POINT_SIZE = 2;
    pub const SCALE_MULTIPLIER = 3;

    pub const base_config = BaseConfig{
        .container_name = "Canvas",
        .maintain_aspect = false,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = MAX_WIDTH,
        .max_height = MAX_HEIGHT,
        .padding_x = 5,
        .padding_y = 5,
        .ratio = 0.663,
        .sticky = true,
        .sticky_anchor = StickyAnchor.TopCenter,
        .scale = false,
        .resizeable = false,
        .border_radius = 0,
    };
};

pub const Collaborators = struct {
    const X = 5;
    const Y = 5;
    const WIDTH = 25;
    const HEIGHT = 10;
    const MAX_WIDTH = WIDTH;
    const MAX_HEIGHT = HEIGHT;

    pub const base_config = BaseConfig{
        .container_name = "Collaborators",
        .maintain_aspect = false,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = MAX_WIDTH,
        .max_height = MAX_HEIGHT,
        .padding_x = 10,
        .padding_y = 10,
        .sticky = true,
        .sticky_anchor = StickyAnchor.TopRight,
        .scale = false,
        .resizeable = true,
    };
};

pub const Playback = struct {
    const X = 5;
    const Y = 5;
    const WIDTH = 100;
    const HEIGHT = 10;
    const MAX_WIDTH = WIDTH;
    const MAX_HEIGHT = HEIGHT;

    pub const base_config = BaseConfig{
        .container_name = "Playback",
        .maintain_aspect = false,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = MAX_WIDTH,
        .max_height = MAX_HEIGHT,
        .sticky = true,
        .sticky_anchor = StickyAnchor.BottomCenter,
        .scale = false,
        .resizeable = false,
    };
};

pub const SpeedControl = struct {
    const HEIGHT = 5;
    const WIDTH = 20;
    const X = Tools.base_config.x + Tools.base_config.width + 1;
    const Y = Tools.base_config.y + Tools.base_config.height - HEIGHT - 1.5;

    pub const base_config = BaseConfig{
        .container_name = "SpeedControl",
        .maintain_aspect = false,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = WIDTH,
        .max_height = HEIGHT,
        .ratio = null,
        .padding_x = 0,
        .padding_y = 0,
        .sticky = true,
        .sticky_anchor = StickyAnchor.None,
        .scale = false,
        .resizeable = true,
        .border_radius = 0,
    };
};

pub const Timeline = struct {
    const X = 0;
    const Y = if ((Tools.Y + Tools.HEIGHT) >= (Canvas.Y + Canvas.HEIGHT))
        Tools.Y + Tools.HEIGHT
    else
        Canvas.Y + Canvas.HEIGHT;
    const WIDTH = 100;
    const HEIGHT = 100 - Y;

    pub const base_config = BaseConfig{
        .container_name = "Playback",
        .maintain_aspect = true,
        .x = X,
        .y = Y,
        .width = WIDTH,
        .height = HEIGHT,
        .max_width = WIDTH,
        .max_height = HEIGHT,
        .ratio = null,
        .padding_x = 0,
        .padding_y = 0,
        .sticky = true,
        .sticky_anchor = StickyAnchor.BottomLeft,
        .scale = false,
        .resizeable = true,
        .border_radius = 0,
    };
};
