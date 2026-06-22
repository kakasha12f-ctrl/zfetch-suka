const std = @import("std");

const MemoryStruct = struct { value: f64, unit: []const u8 };

pub fn memoryinfo(io: anytype, buffer: []u8) !void {
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/meminfo", .{});
    defer file.close(io);

    var reader = file.reader(io, buffer);
    var total_mem: ?usize = null;
    var total_available: ?usize = null;
    while (try reader.interface.takeDelimiter('\n')) |line| {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        if (std.mem.startsWith(u8, line, "MemTotal:")) {
            _ = tokens.next();
            if (tokens.next()) |num_str| {
                total_mem = try std.fmt.parseInt(usize, num_str, 10);
            }
        }

        if (std.mem.startsWith(u8, line, "MemAvailable:")) {
            _ = tokens.next();
            if (tokens.next()) |num_str| {
                total_available = try std.fmt.parseInt(usize, num_str, 10);
            }
        }

        if (total_mem != null and total_available != null) {
            break;
        }
    }

    const total_mem_f = formatMem(total_mem);
    const total_available_f = formatMem(total_available);

    std.debug.print("\x1b[1;33mMemory:\x1b[0m {:.2} {s} / {:.2} {s}\n\n", .{ total_mem_f.value, total_mem_f.unit, total_available_f.value, total_available_f.unit });
}

pub fn formatMem(num: ?usize) MemoryStruct {
    const f = @as(f64, @floatFromInt(num.?));

    if (f < 1024) {
        return .{ .value = f, .unit = "KB" };
    } else if (f < 1024 * 1024) {
        return .{ .value = f / 1024, .unit = "MB" };
    } else {
        return .{ .value = f / 1024 / 1024, .unit = "GB" };
    }
}
