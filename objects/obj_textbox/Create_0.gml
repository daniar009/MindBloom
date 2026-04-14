depth = -9999;

// Textbox sizing (designed for 640x360 viewport)
textbox_width = 520;
textbox_height = 100;
border = 10;
line_sep = 16;

// Portrait area
portrait_size = 64;
portrait_padding = 10;

// Text area starts after portrait
text_area_x = portrait_size + portrait_padding * 2;
text_line_width = textbox_width - text_area_x - border;

// Textbox sprite (nine-slice background)
txtb_spr = spr_menu_1;
txtb_img = 0;
txtb_img_speed = 0;

// Page tracking
page = 0;
page_number = 0;
text[0] = "";
speaker[0] = "";
portrait[0] = -1;

text_length = 0;
draw_char = 0;
text_speed = 0.75;

// Options
option[0] = "";
option_link_id[0] = -1;
option_pos = 0;
option_number = 0;

setup = false;
