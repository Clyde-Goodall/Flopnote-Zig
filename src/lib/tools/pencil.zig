const std = @import("std");
const rl = @import("raylib");
const tools = @import("../data/tools.zig");
const layer = @import("../data/layer.zig");
const patterns = @import("../data/patterns.zig");

pub fn applyTool(tool_type: tools.ToolType, tool_pattern: tools.ToolPattern, tool_size: tools.ToolSize, layer_data: *std.aray_list.Managed(layer.Data), _: rl.Vector2) void {
    switch (tool_type) {
        .Pencil => {
            const solid_layer = &layer_data.masks.get(patterns.LayerPatterns.solid);
            pencil(tool_size, solid_layer);
        },
        .Paint => {
            paint(tool_size, tool_pattern);
        },
    }
}

fn pencil(_: tools.ToolSize, _: *layer.Data) void {
    // todo
}

fn paint(_: tools.ToolSize, _: *layer.Data) void {
    // todo
}
