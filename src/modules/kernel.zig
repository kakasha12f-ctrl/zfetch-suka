const std = @import("std");

pub fn kernel(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/sys/kernel/osrelease", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);
    if (try reader.interface.takeDelimiter('\n')) |line| {
        std.debug.print("\x1b[1;33mKernel:\x1b[0m {s}\n\n", .{line});
    }
}
