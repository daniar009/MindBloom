// Tutorial overlay — blocks input until the player taps to dismiss.
// Set tut_type after creation:
//   "pushblock", "memory", "quiz", "speech"
tut_type = "pushblock";
alpha    = 0;        // fades in
alive    = true;
fade_in  = true;

// --- Pushblock demo animation ---
// Simplified mini-level: 6-column row.
// Maxwell at col 0, block at col 2, target at col 4.
// Steps: walk right, walk right (next to block), push, push (onto target), celebrate.
demo_timer    = 0;       // frame counter within current step
demo_step     = 0;       // which phase of the demo (0..5)
demo_step_len = 40;      // frames per movement step
demo_pause    = 80;      // pause frames at start and after solve
demo_maxwell_col = 0;    // Maxwell's grid column (float for lerp)
demo_block_col   = 2;    // block's grid column (float for lerp)
demo_solved      = false;
demo_looping     = true;
