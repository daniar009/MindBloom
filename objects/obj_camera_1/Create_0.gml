// -----------------------------------------
// CAMERA CONFIG
// -----------------------------------------

// Dead zone — invisible rectangle around the view center.
// Camera only drifts toward the player when they leave this box.
// Bigger numbers = calmer camera (good for young players).
dead_zone_half_w = 64;
dead_zone_half_h = 48;

// How quickly the camera catches up once the player leaves the zone.
// Lower = lazier and smoother.
follow_lerp = 0.10;

// -----------------------------------------
// SCREEN SHAKE
// Use the camera_shake(amount) helper in scr_save_load to trigger.
// -----------------------------------------
shake_amount = 0;   // current strength in pixels
shake_decay  = 1.5; // how many pixels we lose per frame
shake_x = 0;
shake_y = 0;

// Kiss zoom — slow, smooth zoom centered on the player
zoom_timer    = 0;
zoom_duration = 60;   // total frames (~1 second, nice and gentle)
zoom_amount   = 0.04; // how much to zoom (4% — subtle)

// Base view size (set once, never changes — zoom reads from these)
base_view_w = 0;
base_view_h = 0;
