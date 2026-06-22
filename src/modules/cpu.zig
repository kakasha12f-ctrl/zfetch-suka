const std = @import("std");

pub fn cpuinfo(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/cpuinfo", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);

    while (try reader.interface.takeDelimiter('\n')) |line| {
        if (std.mem.startsWith(u8, line, "model name")) {
            var tokens = std.mem.tokenizeScalar(u8, line, ':');

            _ = tokens.next();

            if (tokens.next()) |raw| {
                const cpu_name = std.mem.trim(u8, raw, " ");
                std.debug.print("\x1b[1;33mCPU:\x1b[0m {s}\n\n", .{cpu_name});
                break;
            }
        }
    }
}
