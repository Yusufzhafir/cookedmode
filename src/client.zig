const cookedmode = @import("cookedmode");
const std = @import("std");

pub fn run(writer: *const std.Io.Writer) !void {
    var game = cookedmode.initGame();
    cookedmode.applyAction(&game, .start);
    try render(writer, &game);
}

pub fn render(writer: *const std.Io.Writer, game: *const cookedmode.Game) !void {
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
