//! Shared game state and rules live here so the terminal client is just one frontend.
const std = @import("std");

pub const core = @import("core.zig");

pub const kitchen_rows = core.kitchen_rows;
pub const Game = core.Game;
pub const GamePhase = core.GamePhase;
pub const Tile = core.Tile;
pub const StationKind = core.StationKind;
pub const IngredientKind = core.IngredientKind;
pub const PrepState = core.PrepState;
pub const Item = core.Item;
pub const Position = core.Position;
pub const PlayerAction = core.PlayerAction;
pub const Player = core.Player;
pub const Order = core.Order;
pub const initGame = core.initGame;
pub const tileAt = core.tileAt;
pub const stationKind = core.stationKind;
pub const isWalkable = core.isWalkable;
pub const applyAction = core.applyAction;
pub const tick = core.tick;

test "package exports reach the shared core" {
    const game = initGame();
    try std.testing.expectEqual(GamePhase.start, game.phase);
    try std.testing.expectEqual(Tile.prep_station, tileAt(.{ .row = 1, .col = 4 }));
}
