grid_size = 32;
tile_size = 32;

collision_tilemap = layer_tilemap_get_id("collision");

// Sprite mapping: index matches face direction macros
sprite[RIGHT] = spr_player_move_right;
sprite[UP]    = spr_player_idle_left;    // no up sprite yet
sprite[LEFT]  = spr_player_move_left;
sprite[DOWN]  = spr_player_idle_right;   // no down sprite yet
sprite[IDLEL] = spr_player_idle_left;
sprite[IDLER] = spr_player_idle_right;

face = IDLER;

// Remembers whether the player last faced LEFT or RIGHT.
// Used when walking up/down so the sprite keeps the horizontal look
// instead of having no dedicated up/down sprite.
last_h_face = RIGHT;

// Animation
anim_timer = 0;
anim_duration = 20;

// Smooth movement
moving = false;
move_from_x = x;
move_from_y = y;
move_to_x = x;
move_to_y = y;
move_timer = 0;
move_duration = 6;  // frames to slide one tile

// -----------------------------------------
// Input buffer — remembers one direction pressed mid-slide so
// the next tile can start instantly when the current slide ends.
// -----------------------------------------
buffered_h  = 0;
buffered_v  = 0;
buffer_timer = 0;
buffer_max   = 8;   // how many frames a buffered input stays alive

// -----------------------------------------
// Hold-to-walk: number of frames each direction has been held.
// A tap (under hold_threshold) only moves one tile; holding longer
// than the threshold starts continuous walking.
// -----------------------------------------
hold_right = 0;
hold_left  = 0;
hold_up    = 0;
hold_down  = 0;
hold_threshold = 10;  // ~0.17s at 60fps — longer than any reasonable tap

// -----------------------------------------
// Bump feedback — tiny visual shake when blocked by a wall so the
// player can see their input registered but the tile is blocked.
// -----------------------------------------
bump_x = 0;
bump_y = 0;
bump_timer = 0;
bump_max   = 8;

// -----------------------------------------
// Direction anticipation — a 1-frame hold at the start of each slide
// where facing has updated but position hasn't, so the sprite flip
// is clearly visible before the smooth slide begins.
// -----------------------------------------
slide_start_delay = 1;
