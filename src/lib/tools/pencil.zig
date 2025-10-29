const std = @import("std");
const rl = @import("raylib");
const tools = @import("../data/tools.zig");
const layer = @import("../data/layer.zig");
const patterns = @import("../data/patterns.zig");

pub fn apply(tool_pattern: tools.ToolPatternType, tool_size: tools.ToolSize, layer_data: *std.aray_list.Managed(layer.Data), _: rl.Vector2) void {
    switch (tool_pattern) {
        tools.ToolPatternType.A => {
            const solid_layer = &layer_data.masks.get(patterns.LayerPatterns.solid);
            pencil(tool_size, solid_layer);
        },
        tools.ToolPatternType.B => {
            const solid_layer = &layer_data.masks.get(patterns.LayerPatterns.solid);
            pencil(tool_size, solid_layer);
        },
    }
}

fn pencil(_: tools.ToolSize, _: *layer.Data) void {
    // todo
}