const std = @import("std");
const cookedmode = @import("cookedmode");
const client = @import("client.zig");

pub fn main(init: std.process.Init) !void {
    var buf: [1024]u8 = undefined;
    const io = init.io;

    var writer: std.Io.Writer = .fixed(&buf);
    try writer.writeAll("ALKSDJASLKDJALSKJKD");
    const stdout_file_writer: std.Io.File.Writer = .init(.stdout(), io, &buf);
    const stdout_writer = &stdout_file_writer.interface;

    std.debug.print("this is buf ${s}\n", .{buf});
    try writer.flush();
    std.debug.print("this is buf ${s}\n", .{buf});

    // defer stdOut.deinit();
    // const stdout = &stdout_writer.interface;
    try client.run(stdout_writer);
    try stdout_writer.flush();
}

test "main executable can use the shared game scaffold" {
    var game = cookedmode.initGame();
    cookedmode.applyAction(&game, .start);
    try std.testing.expectEqual(cookedmode.GamePhase.playing, game.phase);
}
