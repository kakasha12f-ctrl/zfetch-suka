const std = @import("std");

pub fn wmde(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/self/environ", .{});
    defer file.close(io);

    std.debug.print("\x1b[1;33mWM/DE:\x1b[0m ", .{});
    var found: bool = false;
    var reader = file.reader(io, buffer);
    while (try reader.interface.takeDelimiter(0)) |env_str| {
        if (std.mem.startsWith(u8, env_str, "DESKTOP_SESSION=") or
            std.mem.startsWith(u8, env_str, "XDG_CURRENT_DESKTOP") or
            std.mem.startsWith(u8, env_str, "XDG_SESSION_DESKTOP="))
        {
            const eq_mem = std.mem.indexOfScalar(u8, env_str, '=') orelse continue;
            const value = env_str[eq_mem + 1 ..];

            if (value.len > 0) {
                std.debug.print("{s} ", .{value});
                found = true;
            }
        }
    }

    if (!found) std.debug.print("unknown ", .{});
    std.debug.print("\n\n", .{});
}
