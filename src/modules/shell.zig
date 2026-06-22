const std = @import("std");

pub fn shell(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/self/environ", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);
    while (try reader.interface.takeDelimiter(0)) |line| {
        if (std.mem.startsWith(u8, line, "SHELL=")) {
            const index_right = std.mem.indexOfScalar(u8, line, '=') orelse continue;
            const value = line[index_right + 1 ..];
            const index_left = std.mem.lastIndexOfScalar(u8, value, '/') orelse continue;
            const value_slice = value[index_left + 1 ..];
            std.debug.print("\x1b[1;33mShell:\x1b[0m {s}\n\n", .{value_slice});
        }
    }
}
