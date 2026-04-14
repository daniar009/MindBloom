solved = false;
solve_timer = 0;

// Move counter — incremented by obj_player when a successful tile move starts
move_count = 0;

// One-step undo state — populated by obj_player when it pushes a block
has_undo       = false;
undo_block     = noone;
undo_block_x   = 0;
undo_block_y   = 0;
undo_player_x  = 0;
undo_player_y  = 0;

// Stuck-hint timer — counts step frames since the last successful move.
// Pops a hint after ~10s of no progress.
idle_timer       = 0;
stuck_hint_after = 600;  // ~10s @ 60fps

// Which level am I (1..4) — for HUD and best-time storage
level_num = 1;
if      (room == rm_puzzle_1_2) level_num = 2;
else if (room == rm_puzzle_1_3) level_num = 3;
else if (room == rm_puzzle_1_4) level_num = 4;

// ===================================================
// FIRST-PLAY TUTORIAL (built-in, no separate object)
// Animated demo: Maxwell pushes a block onto a target
// ===================================================
tutorial_active = false;
tut_alpha       = 0;
tut_timer       = 0;
tut_step        = 0;
tut_step_len    = 40;   // frames per movement
tut_pause       = 80;   // pause frames at start/end
tut_cat_col     = 0;    // Maxwell's column (float)
tut_block_col   = 2;    // block column (float)
tut_solved      = false;

if (room == rm_puzzle_1_1 && !global.tutorial_shown_pushblock) {
    global.tutorial_shown_pushblock = true;
    tutorial_active = true;
}
