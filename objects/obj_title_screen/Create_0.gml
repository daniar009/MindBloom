// Title screen state
anim_timer = 0;

// Button hover states
btn_new_hover      = false;
btn_continue_hover = false;
btn_exit_hover     = false;

has_save = save_exists();

random_set_seed(31415);

// --- Clouds (parallel arrays) ---
cloud_count = 5;
cloud_x     = array_create(cloud_count);
cloud_y     = array_create(cloud_count);
cloud_scale = array_create(cloud_count);
cloud_speed = array_create(cloud_count);
for (var i = 0; i < cloud_count; i++) {
    cloud_x[i]     = irandom(640);
    cloud_y[i]     = 30 + irandom(90);
    cloud_scale[i] = 0.8 + random(0.6);
    cloud_speed[i] = 0.08 + random(0.10);
}

// --- Flowers along the grass ---
flower_count  = 28;
flower_x      = array_create(flower_count);
flower_y      = array_create(flower_count);
flower_r      = array_create(flower_count);
flower_g      = array_create(flower_count);
flower_b      = array_create(flower_count);
flower_phase  = array_create(flower_count);
for (var i = 0; i < flower_count; i++) {
    flower_x[i]     = irandom(640);
    flower_y[i]     = 310 + irandom(40);
    flower_phase[i] = random(6.28);
    var _pick = irandom(4);
    if (_pick == 0) { flower_r[i] = 255; flower_g[i] = 200; flower_b[i] = 220; }
    if (_pick == 1) { flower_r[i] = 255; flower_g[i] = 240; flower_b[i] = 140; }
    if (_pick == 2) { flower_r[i] = 220; flower_g[i] = 180; flower_b[i] = 255; }
    if (_pick == 3) { flower_r[i] = 255; flower_g[i] = 180; flower_b[i] = 180; }
    if (_pick == 4) { flower_r[i] = 200; flower_g[i] = 230; flower_b[i] = 255; }
}

// --- Butterflies (parallel arrays, no structs) ---
butterfly_count = 3;
butterfly_bx    = array_create(butterfly_count);
butterfly_by    = array_create(butterfly_count);
butterfly_ph    = array_create(butterfly_count);
butterfly_sp    = array_create(butterfly_count);
butterfly_rad   = array_create(butterfly_count);
butterfly_col_r = array_create(butterfly_count);
butterfly_col_g = array_create(butterfly_count);
butterfly_col_b = array_create(butterfly_count);
var _wcol_r = [255, 255, 200];
var _wcol_g = [180, 230, 220];
var _wcol_b = [220, 140, 255];
for (var i = 0; i < butterfly_count; i++) {
    butterfly_bx[i]    = 100 + irandom(440);
    butterfly_by[i]    = 160 + irandom(80);
    butterfly_ph[i]    = random(6.28);
    butterfly_sp[i]    = 0.015 + random(0.010);
    butterfly_rad[i]   = 25 + irandom(30);
    butterfly_col_r[i] = _wcol_r[i];
    butterfly_col_g[i] = _wcol_g[i];
    butterfly_col_b[i] = _wcol_b[i];
}

// --- Rising hearts ---
heart_count = 8;
heart_x     = array_create(heart_count);
heart_y     = array_create(heart_count);
heart_speed = array_create(heart_count);
heart_phase = array_create(heart_count);
heart_scale = array_create(heart_count);
for (var i = 0; i < heart_count; i++) {
    heart_x[i]     = irandom(640);
    heart_y[i]     = irandom(360);
    heart_speed[i] = 0.2 + random(0.3);
    heart_phase[i] = random(6.28);
    heart_scale[i] = 0.6 + random(0.6);
}

// --- Sparkles in the sky ---
sparkle_count = 20;
sparkle_x     = array_create(sparkle_count);
sparkle_y     = array_create(sparkle_count);
sparkle_phase = array_create(sparkle_count);
for (var i = 0; i < sparkle_count; i++) {
    sparkle_x[i]     = irandom(640);
    sparkle_y[i]     = irandom(220);
    sparkle_phase[i] = random(6.28);
}

global.paused = false;
