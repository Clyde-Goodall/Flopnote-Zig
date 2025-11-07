const std = @import("std");
const rl = @import("raylib");
const gui = @import("lib/components/gui.zig");
const workspace = @import("lib/data/workspace.zig");
const patterns = @import("lib/data/patterns.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var app = try gui.Root.init(allocator);
    defer app.deinit();
    app.initPointers();
    _ = try app.initComponentBehaviors();
    app.start();
}
