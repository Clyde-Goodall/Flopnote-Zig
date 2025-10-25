const std = @import("std");
const layer = @import("layer.zig");
const frame = @import("frame.zig");

pub const Data = struct {
    const Self = @This();
    allocator: std.mem.Allocator,
    project_name: []const u8,
    date_created: i64, // timestamp
    date_updated: i64,
    frames: std.array_list.Managed(frame.Data),
    playback_speed: i8,

    pub fn init(allocator: std.mem.Allocator, project_name: ?[]const u8) !Self {
        const project_name_unwrapped = project_name orelse "Untitled Project"; //orelse fucks, man. love it
        var frames = std.array_list.Managed(frame.Data).init(allocator);
        frames.append(try frame.Data.init(allocator)) catch unreachable;
        frames.append(try frame.Data.init(allocator)) catch unreachable;

        return Self{
            .allocator = allocator,
            .project_name = project_name_unwrapped,
            .frames = frames,
            .date_created = 1,
            .date_updated = 1,
            .playback_speed = 4,
        };
    }

    pub fn appendNewFrame(self: *Self) void {
        self.frames.append(frame.Data.init(self.allocator));
    }
};
