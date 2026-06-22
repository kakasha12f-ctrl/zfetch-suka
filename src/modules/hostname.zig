const std = @import("std");

pub fn hostname(io: anytype, buffer: []u8) !void {
    var file = try std.Io.Dir.openFileAbsolute(io, "/etc/hostname", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);
    var host: []const u8 = undefined;
    if (try reader.interface.takeDelimiter('\n')) |line| {
        host = line;
    }

    std.debug.print("\x1b[1;33mHostname:\x1b[0m {s}\n\n", .{host});
}

pub fn name(io: anytype, buffer: []u8) !void {
    var file = try std.Io.Dir.openFileAbsolute(io, "/proc/self/environ", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);
    while (try reader.interface.takeDelimiter(0)) |line| {
        if (std.mem.startsWith(u8, line, "USER=")) {
            const index = std.mem.indexOfScalar(u8, line, '=') orelse continue;
            const value = line[index + 1 ..];
            std.debug.print("\x1b[1;33mName:\x1b[0m {s}\n\n", .{value});
            break;
        }
    }
}
