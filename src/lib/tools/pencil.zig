const std = @import("std");
const rl = @import("raylib");
const tools = @import("../data/tools.zig");
const layer = @import("../data/layer.zig");
const patterns = @import("../data/patterns.zig");

pub fn applyTool(tool_type: tools.ToolType, tool_size: tools.ToolSize, layer_data: *layer.Data, pos: rl.Vector2) void {
    switch (tool_type) {
        .Pencil => {
            pencil(tool_size, layer_data.masks.get(patterns.Patterns.solid));
            
        },
        .Paint => {
            paint()
        }
    }
}

fn pencil(tool_size: tools.ToolSize, layer_data: *layer.Data) void{
    
}

fn paint(tool_size: tools.ToolSize, layer_data: *layer.Data) void{
    
}