// Interior controller — handles door exit, wandering cat, welcome flash,
// and hover labels for the cozy knick-knacks.

// Welcome banner fades in at the start and slowly fades away.
welcome_timer = 180;   // frames of full opacity + fade-out tail
welcome_fade  = 60;    // last N frames are the fade

// Door region on the south wall — player must stand on/near it and press E
// to leave. Set in room creation code so values match the room layout.
door_x1 = 288;
door_y1 = 320;
door_x2 = 352;
door_y2 = 384;

// Maxwell the cat idles around the rug. Simple waypoint wander.
cat_x       = 320;
cat_y       = 200;
cat_home_x  = 320;
cat_home_y  = 200;
cat_target_x = cat_x;
cat_target_y = cat_y;
cat_move_speed = 0.4;
cat_pause_timer = 60;  // waits a bit between hops
cat_facing = 1;        // 1 = right, -1 = left

// Fireplace crackle — a handful of sparks that drift up and fade.
sparks = [];
for (var _i = 0; _i < 6; _i++) {
    array_push(sparks, {
        x: 320 + random_range(-4, 4),
        y: 96 + random_range(0, 6),
        vx: random_range(-0.3, 0.3),
        vy: random_range(-0.8, -1.4),
        life: irandom_range(20, 60),
        max_life: 60
    });
}

// The hover label — shows a little caption when the player stands near
// an object of interest. Cleared each frame and re-set by proximity
// checks in the Step event.
hover_label = "";
