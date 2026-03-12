// Interior room boot: make sure the camera tracks the player, and
// point the player at the door so the first thing they see is the
// room centered below them.

// obj_camera_1 is persistent, so it already exists. Snap it to the
// player's spawn so there's no initial drift when the interior appears.
if (instance_exists(obj_camera_1) && instance_exists(obj_player)) {
    var _p = instance_find(obj_player, 0);
    with (obj_camera_1) {
        // Centre the camera on the player instantly. The smoothing lerp
        // in the camera's Step event will keep it locked afterwards.
        x = _p.x - camera_get_view_width(view_camera[0]) / 2;
        y = _p.y - camera_get_view_height(view_camera[0]) / 2;
    }
}

// Face the player up toward the room's contents on arrival.
if (instance_exists(obj_player)) {
    with (instance_find(obj_player, 0)) {
        face = IDLER;
        last_h_face = RIGHT;
    }
}
