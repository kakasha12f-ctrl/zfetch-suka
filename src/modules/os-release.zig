const std = @import("std");

pub fn os_release(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/etc/os-release", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);

    var os: []const u8 = undefined;
    var full_os: []const u8 = undefined;
    var build_id: []const u8 = undefined;
    var count_complete: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        if (std.mem.startsWith(u8, line, "PRETTY_NAME=")) {
            os = std.mem.trim(u8, line, "PRETTY_NAME=");
            full_os = std.mem.trim(u8, os, "\"");
            count_complete += 1;
        }

        if (std.mem.startsWith(u8, line, "BUILD_ID=")) {
            build_id = std.mem.trim(u8, line, "BUILD_ID=");
            count_complete += 1;
        }

        if (count_complete >= 2) {
            break;
        }
    }

    std.debug.print("\x1b[1;33mOS:\x1b[0m {s} {s}\n\n", .{ full_os, build_id });
}
