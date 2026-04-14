// Don't advance while paused or talking
if (global.paused) exit;
if (instance_exists(obj_textbox)) exit;

// -----------------------------------------
// WELCOME BANNER — ticks down once per visit
// -----------------------------------------
if (welcome_timer > 0) welcome_timer--;

// -----------------------------------------
// MAXWELL'S LITTLE WANDER
// He picks a random spot near the rug, ambles over, then pauses.
// -----------------------------------------
var _dx = cat_target_x - cat_x;
var _dy = cat_target_y - cat_y;
var _dist = sqrt(_dx * _dx + _dy * _dy);

if (_dist > cat_move_speed) {
    cat_x += (_dx / _dist) * cat_move_speed;
    cat_y += (_dy / _dist) * cat_move_speed;
    if (_dx > 0.1)      cat_facing =  1;
    else if (_dx < -0.1) cat_facing = -1;
} else {
    cat_x = cat_target_x;
    cat_y = cat_target_y;

    if (cat_pause_timer > 0) {
        cat_pause_timer--;
    } else {
        // Pick a new target inside a small circle around the rug
        var _r = random(28);
        var _a = random(360);
        cat_target_x = cat_home_x + lengthdir_x(_r, _a);
        cat_target_y = cat_home_y + lengthdir_y(_r, _a);
        cat_pause_timer = irandom_range(30, 120);
    }
}

// -----------------------------------------
// FIRE SPARKS — drift up, fade, respawn at the hearth
// -----------------------------------------
for (var _i = 0; _i < array_length(sparks); _i++) {
    var _s = sparks[_i];
    _s.x += _s.vx;
    _s.y += _s.vy;
    _s.vy += 0.02;   // slight buoyancy easing
    _s.life--;
    if (_s.life <= 0) {
        _s.x = 320 + random_range(-4, 4);
        _s.y = 96 + random_range(0, 4);
        _s.vx = random_range(-0.3, 0.3);
        _s.vy = random_range(-0.8, -1.4);
        _s.life = irandom_range(20, 60);
    }
}

// -----------------------------------------
// HOVER LABELS — reset every frame, set based on player position
// -----------------------------------------
hover_label = "";
if (instance_exists(obj_player)) {
    var _px = obj_player.x;
    var _py = obj_player.y;

    // Fireplace (top center)
    if (_px >= 288 && _px <= 352 && _py >= 96 && _py <= 160) {
        hover_label = tr("interior_fire_label");
    }
    // Rug + Maxwell (center)
    else if (_px >= 256 && _px <= 384 && _py >= 192 && _py <= 256) {
        // If cat is in the rug area too, prefer the cat line
        if (point_distance(_px, _py, cat_x, cat_y) < 48) {
            hover_label = tr("interior_cat_label");
        } else {
            hover_label = tr("interior_rug_label");
        }
    }
    // Bookshelf (left wall)
    else if (_px >= 32 && _px <= 96 && _py >= 96 && _py <= 224) {
        hover_label = tr("interior_books_label");
    }
    // Framed photos (left wall, lower)
    else if (_px >= 32 && _px <= 96 && _py >= 224 && _py <= 288) {
        hover_label = tr("interior_photo_label");
    }
    // Window (right wall, upper)
    else if (_px >= 544 && _px <= 608 && _py >= 96 && _py <= 192) {
        hover_label = tr("interior_window_label");
    }
    // Feather on right shelf
    else if (_px >= 512 && _px <= 608 && _py >= 192 && _py <= 224) {
        hover_label = tr("interior_feather_label");
    }
    // Bell on right lower shelf
    else if (_px >= 512 && _px <= 608 && _py >= 224 && _py <= 288) {
        hover_label = tr("interior_bell_label");
    }
    // Sofa + table (lower left)
    else if (_px >= 128 && _px <= 256 && _py >= 224 && _py <= 288) {
        hover_label = tr("interior_sofa_label");
    }
    // Plant pot (lower right corner, near door)
    else if (_px >= 416 && _px <= 480 && _py >= 256 && _py <= 320) {
        hover_label = tr("interior_plant_label");
    }
}

// -----------------------------------------
// DOOR EXIT — press E while standing on the doormat
// -----------------------------------------
if (instance_exists(obj_player) && keyboard_check_pressed(ord("E"))) {
    var _px = obj_player.x;
    var _py = obj_player.y;
    if (_px >= door_x1 && _px <= door_x2 && _py >= door_y1 - 32 && _py <= door_y2) {
        transition_to(Room1);
    }
}
