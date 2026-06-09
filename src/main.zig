const std = @import("std");
const cookedmode = @import("cookedmode");
const client = @import("client.zig");

pub fn main(init: std.process.Init) !void {
    var buf: [1024]u8 = undefined;
    var stdin_buffer: [1024]u8 = undefined;

    const io = init.io;
    var stdout_file_writer: std.Io.File.Writer = .init(.stdout(), io, &buf);
    const stdout_writer = &stdout_file_writer.interface;

    var stdout_file_reader: std.Io.File.Reader = .init(.stdin(), io, &stdin_buffer);
    const stdin_reader = &stdout_file_reader.interface;
    // defer stdOut.deinit();
    // const stdout = &stdout_writer.interface;
    try client.run(stdout_writer, stdin_reader);
    try stdout_file_writer.flush();
    _ = try stdin_reader.discardRemaining();
}

test "main executable can use the shared game scaffold" {
    var game = cookedmode.initGame();
    cookedmode.applyAction(&game, .start);
    try std.testing.expectEqual(cookedmode.GamePhase.playing, game.phase);
}
