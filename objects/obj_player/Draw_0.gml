// -----------------------------------------
// TARGET TILE HIGHLIGHT
// Soft glow on the cell the player is sliding into. Helps young
// players see the grid structure and where they're heading.
// Player's origin sits at the bottom-right of its tile, so the
// target tile spans (move_to_x - 32, move_to_y - 32) to (move_to_x, move_to_y).
// -----------------------------------------
if (moving) {
    var _tx1 = move_to_x - 32;
    var _ty1 = move_to_y - 32;
    var _tx2 = move_to_x - 1;
    var _ty2 = move_to_y - 1;

    // Soft fill
    draw_set_alpha(0.25);
    draw_set_colour(make_colour_rgb(255, 240, 180));
    draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);

    // Bright outline
    draw_set_alpha(0.6);
    draw_rectangle(_tx1, _ty1, _tx2, _ty2, true);

    draw_set_alpha(1);
    draw_set_colour(c_white);
}

// -----------------------------------------
// PLAYER SPRITE (with bump offset for blocked-wall feedback)
// bump_x/y are visual-only — they don't affect collisions or position.
// -----------------------------------------
// Idle breathing bob — subtle when not moving
var _breath_y = moving ? 0 : sin(current_time / 400) * 1;

draw_sprite_ext(
    sprite_index, image_index,
    x + round(bump_x), y + round(bump_y) + _breath_y,
    image_xscale, image_yscale, image_angle, image_blend, image_alpha
);

// -----------------------------------------
// GUIDE ARROW — points toward the next NPC to visit in Room1.
// Sequence: Maxwell (pushblock) → Mira (memory) → Sage (quiz) → Echo (speech).
// Hides when the player is close enough to see the NPC.
// -----------------------------------------
if (room == Room1) {
    var _target = noone;
    if      (!global.puzzle_complete[0] && instance_exists(obj_npc_1)) _target = obj_npc_1;
    else if (!global.puzzle_complete[1] && instance_exists(obj_npc_3)) _target = obj_npc_3;
    else if (!global.puzzle_complete[2] && instance_exists(obj_npc_2)) _target = obj_npc_2;
    else if (!global.puzzle_complete[3] && instance_exists(obj_npc_4)) _target = obj_npc_4;

    if (_target != noone) {
        var _dist = point_distance(x, y, _target.x, _target.y);

        // Only show when far enough away (hide when NPC is nearby)
        if (_dist > 90) {
            var _dir = point_direction(x, y, _target.x, _target.y);

            // Float the arrow 28px from the player's center
            var _cx = x - 16;
            var _cy = y - 24;
            var _bob = sin(current_time / 250) * 2;
            var _ax = _cx + lengthdir_x(30 + _bob, _dir);
            var _ay = _cy + lengthdir_y(30 + _bob, _dir);

            // Arrowhead triangle
            var _sz = 8;
            var _tip_x  = _ax + lengthdir_x(_sz, _dir);
            var _tip_y  = _ay + lengthdir_y(_sz, _dir);
            var _left_x = _ax + lengthdir_x(_sz * 0.7, _dir + 140);
            var _left_y = _ay + lengthdir_y(_sz * 0.7, _dir + 140);
            var _right_x = _ax + lengthdir_x(_sz * 0.7, _dir - 140);
            var _right_y = _ay + lengthdir_y(_sz * 0.7, _dir - 140);

            // Shadow
            draw_set_alpha(0.4);
            draw_set_colour(c_black);
            draw_triangle(_tip_x + 1, _tip_y + 1, _left_x + 1, _left_y + 1,
                          _right_x + 1, _right_y + 1, false);

            // Golden fill
            draw_set_alpha(0.9);
            draw_set_colour(make_colour_rgb(255, 220, 80));
            draw_triangle(_tip_x, _tip_y, _left_x, _left_y, _right_x, _right_y, false);

            // Outline
            draw_set_colour(make_colour_rgb(200, 150, 30));
            draw_triangle(_tip_x, _tip_y, _left_x, _left_y, _right_x, _right_y, true);

            draw_set_alpha(1);
            draw_set_colour(c_white);
        }
    }
}
