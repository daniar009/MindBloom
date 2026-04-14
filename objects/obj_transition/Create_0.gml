depth = -20000;  // Always on top of everything (even HUD)

// State: 0 = idle, 1 = fade_out, 2 = fade_in
state = 2;        // Start with fade-in (room just loaded)
alpha = 1;        // Start opaque, fade in to reveal
fade_speed = 0.08;   // ~12 frames for a full fade
target_room = -1;
