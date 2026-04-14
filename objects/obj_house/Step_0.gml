// The house is only enterable once all four puzzles are done.
// When the player stands near the front door they see a prompt;
// pressing E or tapping the door transitions to rm_house_interior.

if (global.paused) exit;
if (instance_exists(obj_textbox)) exit;
if (global.house_stage < 4) exit;
if (!instance_exists(obj_player)) exit;

// House is at (x, y), sprite is 128x128 (origin top-left).
// The door is drawn at local x 52-76, y 62-89 — world center ~(x+64, y+76).
// The house sprite's bottom edge is at y+128. The player gets blocked by the
// solid sprite and ends up standing at y+128 or y+160 (one tile below).
// Use a generous vertical band: anywhere from door centre up to 2 tiles below.
var _door_cx = x + 64;
var _door_cy = y + 76;

var _px = obj_player.x;
var _py = obj_player.y;

near_door = (abs(_px - _door_cx) <= 64 && _py >= _door_cy - 32 && _py <= _door_cy + 160);

// E key entry
if (near_door && keyboard_check_pressed(ord("E"))) {
    transition_to(rm_house_interior);
    exit;
}

// Tap / left-click on the door sprite area (mobile-friendly).
// The clickable zone is the visible door on the house: world x 52-76, y 62-105.
if (mouse_check_button_pressed(mb_left)) {
    var _mx = mouse_x;
    var _my = mouse_y;
    var _in_door = (_mx >= x + 44 && _mx <= x + 84 && _my >= y + 55 && _my <= y + 110);
    if (_in_door && global.house_stage >= 4) {
        transition_to(rm_house_interior);
    }
}
