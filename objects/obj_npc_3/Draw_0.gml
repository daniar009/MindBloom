

var _bob = sin(current_time / 380 + 2.0) * 1;
draw_sprite_ext(sprite_index, image_index, x, y + _bob,
    image_xscale, image_yscale, image_angle, image_blend, image_alpha);

draw_set_font(global.font_main);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_colour(make_colour_rgb(140, 255, 180));
draw_text(x + 16, y - 4 + _bob, "Mira");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_colour(c_white);

draw_npc_checkmark(x, y, global.puzzle_complete[2]);
