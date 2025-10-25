const std = @import("std");
const rl = @import("raylib");
const tools = @import("../data/tools.zig");

pub fn applyTool(tool_type: tools.ToolType, tool_size: tools.ToolSize, layers: std.Layer, pos: rl.Vector2) void {
    switch (tool_type) {
        .Pencil => {
            pencil.apply(tool_type, tool_size, layers)
        }
    }
}