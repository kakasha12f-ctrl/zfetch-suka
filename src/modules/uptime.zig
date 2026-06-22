const std = @import("std");

pub fn uptime(io: anytype, buffer: []u8) !void {

    // открывает файл системы чтобы прочитать время работы с момента запуска или типо того
    const file = try std.Io.Dir.openFileAbsolute(io, "/proc/uptime", .{});
    defer file.close(io); // закрывает файл в конце, чтобы не было утечки памяти

    var reader = file.reader(io, buffer); // записывает данные в buffer
    if (try reader.interface.takeDelimiter('\n')) |line| {
        const space = std.mem.indexOfScalar(u8, line, ' ') orelse line.len;
        const uptime_location = line[0..space];

        const seconds = try std.fmt.parseFloat(f64, uptime_location);
        const minutes = seconds / 60.0;

        std.debug.print("\x1b[1;33mUptime:\x1b[0m {:.1} Minutes ({} seconds)\n\n", .{ minutes, seconds });
    } else {
        std.debug.print("\x1b[1;33mUptime:\x1b[0m Файл пустой!\n\n", .{});
    }
}
