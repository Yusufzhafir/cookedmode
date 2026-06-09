const std = @import("std");

pub const kitchen_rows = [_][]const u8{
    "##########",
    "#I..P...D#",
    "#........#",
    "#....#...#",
    "##########",
};

pub const GamePhase = enum {
    start,
    playing,
    paused,
    game_over,
};

pub const Tile = enum {
    floor,
    wall,
    ingredient_station,
    prep_station,
    delivery_counter,
};

pub const StationKind = enum {
    ingredient,
    prep,
    delivery,
};

pub const IngredientKind = enum {
    onion,
    bun,
};

pub const PrepState = enum {
    raw,
    cut,
    steamed,
};

pub const Item = struct {
    kind: IngredientKind,
    prep: PrepState = .raw,
};

pub const Position = struct {
    row: usize,
    col: usize,
};

pub const PlayerAction = enum {
    none,
    start,
    up,
    down,
    left,
    right,
    interact,
    pause,
    quit,
};

pub const Player = struct {
    position: Position,
    carrying: ?Item = null,
};

pub const Order = struct {
    requested: Item,
    patience_ticks: u32,
};

pub const Game = struct {
    phase: GamePhase = .start,
    player: Player,
    coins: u32 = 0,
    elapsed_ms: u64 = 0,
    active_orders: [2]?Order = .{ null, null },
    last_message: []const u8 = "TODO: replace scaffold state with real game rules.",
};

pub fn initGame() Game {
    return .{
        .player = .{
            .position = .{ .row = 2, .col = 2 },
        },
        .active_orders = .{
            .{
                .requested = .{ .kind = .onion, .prep = .cut },
                .patience_ticks = 30,
            },
            null,
        },
        .last_message = "Scaffold only: you will fill in movement, stations, and orders.",
    };
}

pub fn tileAt(position: Position) Tile {
    if (position.row >= kitchen_rows.len) return .wall;

    const row = kitchen_rows[position.row];
    if (position.col >= row.len) return .wall;

    return switch (row[position.col]) {
        '#' => .wall,
        'I' => .ingredient_station,
        'P' => .prep_station,
        'D' => .delivery_counter,
        else => .floor,
    };
}

pub fn stationKind(tile: Tile) ?StationKind {
    return switch (tile) {
        .ingredient_station => .ingredient,
        .prep_station => .prep,
        .delivery_counter => .delivery,
        else => null,
    };
}

pub fn isWalkable(tile: Tile) bool {
    return switch (tile) {
        .wall => false,
        else => true,
    };
}

pub fn applyAction(game: *Game, action: PlayerAction) void {
    switch (action) {
        .none => {},
        .start => {
            if (game.phase == .start) {
                game.phase = .playing;
                game.last_message = "TODO: start the game loop and spawn/update orders.";
            }
        },
        .pause => switch (game.phase) {
            .playing => {
                game.phase = .paused;
                game.last_message = "Paused. TODO: decide how you want to resume.";
            },
            .paused => {
                game.phase = .playing;
                game.last_message = "Resumed. TODO: keep the timer behavior consistent.";
            },
            else => {},
        },
        .quit => {
            game.phase = .game_over;
            game.last_message = "TODO: decide what quitting means for score and cleanup.";
        },
        .interact => {
            game.last_message = "TODO: look at the player's neighboring tile and apply station rules.";
        },
        .up, .down, .left, .right => {
            game.last_message = "TODO: implement movement and wall checks in core.applyAction.";
            switch (action) {
                .up => {
                    game.player.position.row -= 1;
                },
                .down => {
                    game.player.position.row += 1;
                },
                .left => {
                    game.player.position.col -= 1;
                },
                .right => {
                    game.player.position.col += 1;
                },
                else => {},
            }
        },
    }
}

pub fn tick(game: *Game, dt_ms: u32) void {
    game.elapsed_ms += @as(u64, dt_ms);
}

test "tile lookup matches scaffold map" {
    try std.testing.expectEqual(Tile.ingredient_station, tileAt(.{ .row = 1, .col = 1 }));
    try std.testing.expectEqual(Tile.delivery_counter, tileAt(.{ .row = 1, .col = 8 }));
    try std.testing.expectEqual(Tile.wall, tileAt(.{ .row = 0, .col = 0 }));
}

test "start action flips the phase without adding gameplay rules yet" {
    var game = initGame();
    applyAction(&game, .start);
    try std.testing.expectEqual(GamePhase.playing, game.phase);
}
