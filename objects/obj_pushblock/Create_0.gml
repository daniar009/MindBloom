// Y-sort depth: objects lower on screen (higher Y) draw in front
depth = -y;

tile_size = 32;
collision_tilemap = layer_tilemap_get_id("collision");

startPointX = x;
startPointY = y;
targetX = x;
targetY = y;

sliding = false;
move_timer = 0;
move_duration = 6;  // match player slide speed

on_target      = false;
was_on_target  = false;  // used to detect the first frame a block lands on a target

// Colored blocks: set block_colour in instance creation code.
// "any" = matches any target (backwards compat with existing levels).
// "red"/"blue"/"green" = only matches a target of the same colour.
block_colour = "any";

// Celebratory scale bounce when first landing on a target
bounce_timer  = 0;
bounce_max    = 12;
