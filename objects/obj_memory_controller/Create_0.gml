// How many unique pairs for this level (set via instance creation code)
pair_count  = 2;    // default: 2 pairs = 4 cards
grid_cols   = 2;    // columns
grid_rows   = 2;    // rows

// Tracking
flipped_count = 0;
flipped_cards = array_create(2, noone);
check_timer   = 0;     // delay before checking match (set to ~70 = ~1.15s)
matched_pairs = 0;
total_pairs   = 0;
solved        = false;
solve_timer   = 0;

// Peek-at-start: briefly reveal every card so kids have a chance
peek_timer = 90;       // ~1.5s reveal at level start
peek_active = true;

// Frustration helper: skip button after a few failed pairs
mismatch_count = 0;
skip_allowed   = false;
skip_rect      = [0, 0, 0, 0];

// Will be set up after creation code runs
setup_done = false;

// First-play tutorial overlay
if (room == rm_memory_1 && !global.tutorial_shown_memory) {
    global.tutorial_shown_memory = true;
    var _h = instance_create_depth(0, 0, -30000, obj_tutorial_overlay);
    _h.tut_type = "memory";
}
