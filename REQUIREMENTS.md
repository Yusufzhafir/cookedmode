# Cooked Mode Requirements

## Project Goal

Build **Cooked Mode**, a single-player terminal kitchen game written in Zig.

The game is inspired by Overcooked-style food preparation, but the first version should stay small enough to be a learning project. The goal is not to build the biggest possible game. The goal is to learn Zig, terminal rendering, keyboard input, and game-state modeling by building a playable terminal app step by step.

In Cooked Mode, orders appear, the player moves around a tile-based kitchen, prepares food at stations, submits completed orders, earns coins, and tries to keep up as time passes.

## Learning Goals

This project should help the user practice:

- Writing small Zig programs with clear data types and explicit control flow.
- Using structs, enums, arrays, slices, optionals, and error handling.
- Separating game state from rendering and input decisions.
- Modeling a game loop with repeated input, update, and render steps.
- Representing terminal screens as rows, columns, tiles, and text.
- Understanding stdin, stdout, terminal modes, and keyboard input behavior.
- Learning the difference between cooked terminal input and raw terminal input.
- Using timers, counters, and simple state machines.
- Reading compiler errors and debugging one small behavior at a time.

## Core Game Loop

The first playable version should follow this loop:

1. Show a start screen.
2. Start a new kitchen run.
3. Render the kitchen grid, player, stations, active orders, timer, and coins.
4. Read player input.
5. Update the player position or interact with the current station.
6. Advance order timers and game timers.
7. Award coins when the player submits a correct order.
8. End the run when the game-over condition is reached.

The game should feel responsive enough to play in a normal terminal, but the first version does not need animation, sound, networking, menus, or save files.

## Terminal Requirements

The game should run in a terminal and render using text output.

Required:

- Use a tile-based display with rows and columns.
- Make the player visibly move around the kitchen.
- Clear, redraw, or update the terminal in a way that keeps the screen understandable.
- Show active orders and coins in a fixed status area.
- Avoid printing endless scrolling output during gameplay.
- Restore the terminal to a usable state when the game exits.
- Explain or document any terminal mode changes used by the program.

Recommended for v1:

- Use plain text and ANSI escape sequences directly.
- Keep the grid small enough to fit in a typical terminal window.
- Use simple single-character or short text symbols for tiles, stations, and the player.
- Start with line-based input if needed, then improve toward raw input once the basic game works.

Not required for v1:

- Mouse input.
- Full Unicode art.
- Terminal image protocols.
- External TUI frameworks.
- Smooth animation.
- Resizable layouts.

## Gameplay Requirements

### Player

- The player exists at one tile coordinate on the kitchen grid.
- The player can move up, down, left, and right.
- The player cannot move through walls or blocked stations.
- The player can interact with a station when standing on or next to the relevant tile.
- The player can carry either nothing or one prepared item at a time.

### Kitchen

- The kitchen is a small grid made of tiles.
- The kitchen must include:
  - Floor tiles.
  - Wall or blocked tiles.
  - At least one ingredient station.
  - At least one preparation station.
  - At least one delivery counter.
- Each station should have a clear visual symbol in the terminal.

### Ingredients and Prep

- The first version should support a small ingredient set.
- Suggested starting ingredients:
  - Onion.
  - Bun.
- Suggested starting prep actions:
  - Cut onion.
  - Steam bun.
- A prep action should change the item's state, such as raw to cut or raw to steamed.
- A station interaction should be visible to the player through text, status, or item changes.

### Orders

- Orders appear over time.
- Each order asks for one or more prepared items.
- Each order has a remaining time or patience value.
- The player completes an order by delivering the correct prepared item or items to the delivery counter.
- Correct delivery awards coins.
- Incorrect or incomplete delivery should not award coins.
- Expired orders disappear or count as missed.

### Scoring and End State

- The game tracks coins earned.
- The game tracks elapsed time, remaining time, missed orders, or another simple run-ending condition.
- The game has at least these states:
  - Start.
  - Playing.
  - Paused.
  - Game over.
- The game-over screen shows the final coin total.

## Milestones

### Milestone 1: Static Kitchen

Render a fixed kitchen grid in the terminal.

Acceptance:

- The program shows a recognizable kitchen layout.
- Different tile types are visually distinct.
- The output is stable and easy to read.

Learning focus:

- Zig entry point.
- Basic stdout printing.
- Arrays, slices, and simple tile representation.

### Milestone 2: Player Movement

Add a player position and movement.

Acceptance:

- The player appears on the grid.
- Movement updates the player position.
- Walls or blocked tiles prevent movement.
- The screen does not become an unreadable scrollback log during movement.

Learning focus:

- Coordinates.
- Bounds checks.
- Input handling.
- Updating state separately from rendering.

### Milestone 3: Stations and Interaction

Add stations that the player can interact with.

Acceptance:

- Stations are visible on the grid.
- The player can trigger an interaction at a station.
- The game shows feedback when an interaction happens.

Learning focus:

- Enums for station types.
- Switch statements.
- Small state transitions.

### Milestone 4: Ingredients and Prep States

Add carryable ingredients and simple preparation.

Acceptance:

- The player can pick up an ingredient.
- The player can prepare it at the correct station.
- The player's carried item state is visible.
- Invalid actions give understandable feedback.

Learning focus:

- Optionals.
- Structs for item state.
- Representing domain rules in code.

### Milestone 5: Orders and Delivery

Add active orders and a delivery counter.

Acceptance:

- At least one order appears.
- The order describes what prepared item is needed.
- Delivering the correct item awards coins.
- Delivering the wrong item does not complete the order.

Learning focus:

- Arrays or lists of active orders.
- Matching item state against order requirements.
- Removing or marking completed orders.

### Milestone 6: Timers, Difficulty, and Game Over

Add time pressure.

Acceptance:

- Orders can expire.
- New orders appear over time.
- The game can end.
- The game-over screen shows the final score.

Learning focus:

- Time measurement.
- Game state enums.
- Simple difficulty progression.

### Milestone 7: Terminal Polish

Improve terminal behavior.

Acceptance:

- The game starts and exits cleanly.
- The terminal is restored after exit.
- The screen layout is understandable during normal play.
- The user can pause or quit intentionally.

Learning focus:

- Raw mode versus cooked mode.
- Cleanup paths.
- Signals and interrupted exits where appropriate.
- Debugging terminal state.

## Acceptance Criteria

The project reaches v1 when:

- A user can start the game from the terminal.
- A visible player can move around a tile kitchen.
- The kitchen contains meaningful stations.
- The player can prepare at least two item states.
- Orders appear and can be completed.
- Completing orders awards coins.
- The game has a clear ending condition.
- The game exits without leaving the terminal unusable.
- The code is understandable enough for the user to explain the main state types and game loop.

## Stretch Goals

These are optional and should wait until the core game works:

- Multiple recipes.
- Multiple stations of the same type.
- More ingredients and prep steps.
- Increasing difficulty over time.
- Combo bonuses.
- Title screen art.
- Pause menu.
- High score saved to a file.
- Better color and layout.
- Smooth non-blocking keyboard input.
- Window resize handling.
- Tests for order matching or state transitions.

## Rules for AI Help

Agents should follow `AGENTS.md` while helping with this project.

Agents may:

- Explain Zig concepts.
- Explain terminal behavior.
- Review code the user has written.
- Help interpret compiler errors.
- Suggest small experiments.
- Give small examples that illustrate one concept.

Agents should not:

- Write the full game.
- Fill in whole functions or modules.
- Apply implementation patches for gameplay features.
- Convert this requirements document directly into code.
- Hide the learning process behind finished solutions.

The user should remain the primary author of the Zig code. The agent's job is to guide the learning path.
