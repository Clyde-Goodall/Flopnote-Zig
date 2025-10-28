// const ymlz = @import("ymlz");
// const std = @import("std");

// const Options = struct {
//     window_size: struct {
//         width: i32,
//         height: i32,
//     },
// };

// pub fn loadOptions(allocator: std.mem.Allocator) !Options {
//     const path = try std.fs.cwd().realpathAlloc(
//         allocator,
//         "./config.yaml",
//     );
//     var yml = try ymlz(Options).init(allocator);
//     defer yml.deinit();
//     const results = try yml.loadFile(path);
//     std.debug.print("\nConfig: {any}", .{results});
//     return results;
// }
