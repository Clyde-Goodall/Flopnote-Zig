const rl = @import("raylib");
const defaults = @import("../defaults.zig");
const canvas = @import("canvas.zig");
const timeline = @import("timeline.zig");
const playback = @import("playback.zig");
const menu = @import("menu.zig");
const tools = @import("tools.zig");
const workspace = @import("../data/workspace.zig");
const std = @import("std");

pub const ComponentType = enum { Canvas, Menu, Timeline, Playback, Tools };

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
    };

    pub fn draw(self: *TaggedContainer) void {
        switch (self.component) {
            inline else => |*component| component.draw(),
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

    pub fn init(allocator: std.mem.Allocator) !Self {
        const default_workspace = workspace.Data.init(allocator, null);
        const components = std.array_list.Managed(TaggedContainer).init(allocator);

        var self_root = Self{ .components = components, .wkspace = default_workspace };

        const default_active_frame = &self_root.wkspace.active_project.?.frames.items[0];
        const canvas_component = canvas.Component.init(defaults.Canvas.base_config, default_active_frame);
        const timeline_component = timeline.Component.init(defaults.Timeline.base_config, allocator);
        const tools_component = tools.Component.init(defaults.Tools.base_config);

        const component_slice = &[_]TaggedContainer{
            TaggedContainer{
                .component = .{ .Canvas = canvas_component },
                .child = null,
            },
            TaggedContainer{
                .component = .{ .Timeline = timeline_component },
                .child = null,
            },
            TaggedContainer{
                .component = .{ .Tools = tools_component },
                .child = null,
            },
        };

        try self_root.components.appendSlice(component_slice);

        return self_root;
    }

    pub fn initPointers(self: *Self) void {
        // Set all pointers AFTER the struct is in its final memory location
        self.components.items[1].component.Timeline.setFrames(&self.wkspace.active_project.?.frames);
    }

    pub fn start(self: *Self) void {
        rl.initWindow(
            defaults.Window.base_config.width,
            defaults.Window.base_config.height,
            "Insert Project Name Here",
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
        rl.clearBackground(.black);
        rl.drawRectangle(0, 0, defaults.Window.base_config.width, defaults.Window.base_config.width, .gray);
        rl.beginDrawing();
        defer rl.endDrawing();
        for (self.components.items) |*component| {
            component.draw();
        }
    }

    pub fn deinit(self: *Self) void {
        defer self.components.deinit();
    }
};
