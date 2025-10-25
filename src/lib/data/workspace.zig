const std = @import("std");
const tools = @import("tools.zig");
const project = @import("project.zig");

pub const WorkspaceConfig = struct {
    tool_type: tools.ToolType,
    tool_size: tools.ToolSize,
};

pub const Data = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    active_tool: tools.ToolType,
    active_tool_size: tools.ToolSize,
    active_project: ?project.Data,

    pub fn init(allocator: std.mem.Allocator, new_project_name: ?[]const u8) Self {
        const new_project = project.Data.init(allocator, new_project_name orelse "Untitle Project") catch @panic("Could not initialize new project");
        return Self{
            .allocator = allocator,
            .active_tool = .Pencil,
            .active_tool_size = .Medium,
            .active_project = new_project,
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
};
