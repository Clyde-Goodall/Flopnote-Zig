const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const canvas = @import("canvas.zig");
const timeline = @import("timeline.zig");
const playback = @import("playback.zig");
const menu = @import("menu.zig");
const tools = @import("tools.zig");
const workspace = @import("../data/workspace.zig");
const std = @import("std");
const speed_control = @import("speed_control.zig");
const theme_data = defaults.Theme;
// const yaml_config = @import("../config/config.zig");

pub const ComponentType = enum { Canvas, Menu, Timeline, Playback, Tools, SpeedControl };

pub const Container = struct {
    const Self = @This();

    config: defaults.BaseConfig,
    container: TaggedContainer,

    pub fn init(config: defaults.BaseConfig, container: TaggedContainer) Self {
        return Self{
            .config = config,
            .container = container,
        };
    }

    // pub fn
};

pub const TaggedContainer = struct {
    component: ComponentUnion,
    child: ?*TaggedContainer,

    const ComponentUnion = union(ComponentType) {
        Canvas: canvas.Component,
        Menu: menu.Component,
        Timeline: timeline.Component,
        Playback: playback.Component,
        Tools: tools.Component,
        SpeedControl: speed_control.Component,
    };

    pub fn draw(self: *TaggedContainer) void {
        switch (self.component) {
            inline else => |*component| {
                component.draw() catch |err| {
                    std.debug.print("\n{}", .{err});
                };
            },
        }
        if (self.child) |child| {
            child.draw();
        }
    }

    pub fn update(self: *TaggedContainer) void {
        try switch (self.component) {
            inline else => |*component| component.update(),
        };
    }
};

pub const Root = struct {
    const Self = @This();

    components: std.array_list.Managed(TaggedContainer),
    wkspace: workspace.Data,
    // options: yaml_config.Options,

    pub fn init(allocator: std.mem.Allocator) !Self {
        const default_workspace = workspace.Data.init(allocator, null);
        const components = std.array_list.Managed(TaggedContainer).init(allocator);
        // const opts = yaml_config.loadOptions(allocator);
        var self_root = Self{
            .components = components,
            .wkspace = default_workspace,
            // .options = opts,
        };

        const default_active_frame = &self_root.wkspace.active_project.?.frames.items[0];
        const canvas_component = canvas.Component.init(default_active_frame);
        const timeline_component = timeline.Component.init(allocator);
        const tools_component = tools.Component.init(&self_root.wkspace);
        const speed_control_component = speed_control.Component.init(&self_root.wkspace);

        const component_slice = &[_]TaggedContainer{
            TaggedContainer{
                .component = .{ .Tools = tools_component },
                .child = null,
            },
            TaggedContainer{
                .component = .{ .Canvas = canvas_component },
                .child = null,
            },
            TaggedContainer{
                .component = .{ .SpeedControl = speed_control_component },
                .child = null,
            },
            TaggedContainer{
                .component = .{ .Timeline = timeline_component },
                .child = null,
            },
        };

        try self_root.components.appendSlice(component_slice);
        return self_root;
    }

    pub fn initPointers(self: *Self) void {
        self.components.items[0].component.Tools.wkspace = &self.wkspace;
        self.components.items[2].component.SpeedControl.wkspace = &self.wkspace;
        self.components.items[3].component.Timeline.setFrames(&self.wkspace.active_project.?.frames);
    }

    pub fn initComponentBehaviors(self: *Self) !void {
        try self.components.items[3].component.Timeline.initBehaviors();
    }

    pub fn start(self: *Self) void {
        rl.initWindow(
            defaults.Window.WIDTH,
            defaults.Window.HEIGHT,
            "'Dick Joke' - Jon",
        );
        defer rl.closeWindow();
        rl.setTargetFPS(60);

        while (!rl.windowShouldClose()) {
            self.update();
            self.draw();
        }
    }

    pub fn update(self: *Self) void {
        for (self.components.items) |*component| {
            component.update();
        }
    }

    pub fn draw(self: *Self) void {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(theme_data.BACKGROUND_SOLID);
        drawBackgroundGrid();
        for (self.components.items) |*component| {
            component.draw();
        }
    }

    pub fn deinit(self: *Self) void {
        defer self.components.deinit();
    }
};

fn drawBackgroundGrid() void {
    const grid_square_size = 20;
    const width = defaults.Window.WIDTH;
    const height = defaults.Window.HEIGHT;
    var c: i32 = 0;
    while (c < width) : (c += grid_square_size) {
        const col_int = @as(i32, @intCast(c));
        rl.drawLine(col_int, 0, col_int, height, theme_data.BACKGROUND_GRID_LINES);
    }
    var r: i32 = 0;
    while (r < height) : (r += grid_square_size) {
        const row_int = @as(i32, @intCast(r));
        rl.drawLine(0, row_int, width, row_int, theme_data.BACKGROUND_GRID_LINES);
    }
}
