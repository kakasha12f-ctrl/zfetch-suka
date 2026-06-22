const std = @import("std");

pub fn packets(io: anytype) !void {
    const dir = try std.Io.Dir.cwd().openDir(io, "/var/lib/pacman/local/", .{ .iterate = true });
    defer dir.close(io);

    var iterator = dir.iterateAssumeFirstIteration();
    var count: usize = 0;

    while (try iterator.next(io)) |entry| {
        if (entry.kind == .directory) {
            count += 1;
        }
    }
    std.debug.print("\x1b[1;33mPacman Packages:\x1b[0m {}\n\n", .{count});
}
