const std = @import("std");
const tools = @import("tools.zig");
const project = @import("project.zig");
const patterns = @import("patterns.zig");
const pencil = @import("../tools/pencil.zig");

pub const Data = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    active_tool: tools.ToolType,
    active_tool_pattern: tools.ToolPatternType,
    active_tool_size: tools.ToolSize,
    active_project: ?project.Data,
    playback_speed: i8,

    pub fn init(allocator: std.mem.Allocator, new_project_name: ?[]const u8) Self {
        const new_project = project.Data.init(allocator, new_project_name orelse "Untitled Project") catch @panic("Could not initialize new project");
        return Self{
            .allocator = allocator,
            .active_tool = .Pencil,
            .active_tool_size = tools.ToolSize.Base,
            .active_tool_pattern = tools.ToolPatternType.B,
            .active_project = new_project,
            .playback_speed = 3,
        };
    }

    pub fn changeProject(_: *Self) void {
        return;
    }

    pub fn changeActiveTool(self: *Self, new_tool: tools.ToolType) void {
        self.active_tool = new_tool;
    }

    pub fn listenForToolUpdates(_: *Self) !void {
        return;
    }

    pub fn drawToFrame(self: *Self) void {
        if (self.active_project == null) return;
        switch (self.active_tool) {
            tools.ToolType.Pencil => {
                pencil.apply(
                    self.active_tool_pattern,
                    self.active_tool_size,
                    self.active_project.?.getActiveFrame(),
                );
            },
        }
    }
};
