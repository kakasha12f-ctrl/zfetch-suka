const std = @import("std");
const print = std.debug.print; // print
const zfetch_logotype = @import("src/zfetch-logo.zig").zfetch_logotype;
const hostname = @import("src/modules/hostname.zig").hostname;
const packets = @import("src/modules/packets.zig").packets;
const uptime = @import("src/modules/uptime.zig").uptime;
const memoryinfo = @import("src/modules/memory.zig").memoryinfo;
const kernel = @import("src/modules/kernel.zig").kernel;
const cpuinfo = @import("src/modules/cpu.zig").cpuinfo;
const os_release = @import("src/modules/os-release.zig").os_release;
const wmde = @import("src/modules/wmde.zig").wmde;
const name = @import("src/modules/hostname.zig").name;
const shell = @import("src/modules/shell.zig").shell;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var buffer: [256]u8 = undefined;
    print("\x1b[38;5;208m{s}\x1b[0m\n", .{zfetch_logotype});
    print("\x1b[20A", .{});
    print("\x1b[40C", .{});
    try hostname(io, &buffer);
    print("\x1b[40C", .{});
    try name(io, &buffer);
    print("\x1b[40C", .{});
    try os_release(io, &buffer);
    print("\x1b[40C", .{});
    try packets(io);
    print("\x1b[40C", .{});
    try shell(io, &buffer);
    print("\x1b[40C", .{});
    try wmde(io, &buffer);
    print("\x1b[40C", .{});
    try uptime(io, &buffer);
    print("\x1b[40C", .{});
    try memoryinfo(io, &buffer);
    print("\x1b[40C", .{});
    try kernel(io, &buffer);
    print("\x1b[40C", .{});
    try cpuinfo(io, &buffer);
    print("\x1b[15B\n", .{});
}
