const std = @import("std");
const rl = @import("raylib");

const layer = @import("layer.zig");

pub const Data = struct {
    const Self = @This();
    layers: std.array_list.Managed(layer.Data),
    active: bool,

    pub fn init(allocator: std.mem.Allocator) !Data {
        var layers = std.array_list.Managed(layer.Data).init(allocator);
        layers.append(try layer.Data.init(allocator, rl.Color.black)) catch unreachable;
        return Data{
            .layers = layers,
            .active = false,
        };
    }
};

pub fn drawFrame(
    layers: *std.array_list.Managed(layer.Data),
    _: rl.Vector2,
    _: i32,
) void {
    for (layers) |_| {}
}
