const cookedmode = @import("cookedmode");
const std = @import("std");

const up = [_]u8{ 0x1B, 0x5B, 0x41 };
const down = [_]u8{ 0x1B, 0x5B, 0x42 };
const right = [_]u8{ 0x1B, 0x5B, 0x43 };
const left = [_]u8{ 0x1B, 0x5B, 0x44 };

const eql = std.mem.eql;

pub fn run(writer: *std.Io.Writer, stdin: *std.Io.Reader) !void {
    var game = cookedmode.initGame();
    cookedmode.applyAction(&game, .start);

    var last_input_buf: [8]u8 = undefined;

    while (game.phase != cookedmode.GamePhase.game_over) {
        //render game and flush the buffer
        try render(writer, &game);
        try writer.print("input bytes: {x}\n", .{last_input_buf});
        try writer.flush();

        //take in input
        const maybe_line = try stdin.takeDelimiter('\n');
        const input = maybe_line orelse continue;

        //copy input to previous buffer
        @memset(&last_input_buf, 0);
        const n = @min(input.len, last_input_buf.len);
        std.mem.copyForwards(u8, last_input_buf[0..n], input[0..n]);

        //apply game action
        var gameAction: cookedmode.PlayerAction = undefined;
        if (eql(u8, input, &up)) {
            gameAction = .up;
        } else if (eql(u8, input, &down)) {
            gameAction = .down;
        } else if (eql(u8, input, &left)) {
            gameAction = .left;
        } else if (eql(u8, input, &right)) {
            gameAction = .right;
        } else {
            gameAction = .none;
        }

        cookedmode.applyAction(&game, gameAction);
        cookedmode.tick(&game, 1);
    }
}

pub fn render(writer: *std.Io.Writer, game: *const cookedmode.Game) !void {
    // const writer = writerObj;
    try writer.writeAll("\x1b[2J\x1b[H");
    try writer.print("Cooked Mode\n", .{});
    try writer.print("phase: {s}\n", .{@tagName(game.phase)});
    try writer.print("coins: {d}\n", .{game.coins});
    try writer.print(
        "player: row={d}, col={d}\n",
        .{ game.player.position.row, game.player.position.col },
    );
    try writer.print("message: {s}\n\n", .{game.last_message});

    for (cookedmode.kitchen_rows, 0..) |row, row_index| {
        for (row, 0..) |_, col_index| {
            try writer.print("{c}", .{glyphAt(game, row_index, col_index)});
        }
        try writer.writeAll("\n");
    }

    try writer.writeAll("\nNext step: map one key to one PlayerAction and call applyAction.\n");
}

fn glyphAt(game: *const cookedmode.Game, row: usize, col: usize) u8 {
    if (game.player.position.row == row and game.player.position.col == col) {
        return '@';
    }

    return switch (cookedmode.tileAt(.{ .row = row, .col = col })) {
        .wall => '#',
        .floor => '.',
        .ingredient_station => 'I',
        .prep_station => 'P',
        .delivery_counter => 'D',
    };
}
