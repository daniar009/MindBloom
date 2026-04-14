// Sit between the ground tile layer (depth 200) and instances (depth 0),
// so walls draw above the ground but behind the pushblocks (which use depth=-y).
depth = 50;

// Scan the collision tilemap and build two lists: walls and floor tiles.
// Floor tiles get drawn with wood plank details on top of the ground layer.
wall_list  = [];
floor_list = [];
var _tilemap = layer_tilemap_get_id("collision");

var _cols = room_width div 32;
var _rows = room_height div 32;

for (var _row = 0; _row < _rows; _row++) {
    for (var _col = 0; _col < _cols; _col++) {
        var _tile = tilemap_get(_tilemap, _col, _row);
        if (_tile != 0) {
            // Check neighbors to determine wall shape
            var _up    = (_row > 0)        && (tilemap_get(_tilemap, _col, _row - 1) != 0);
            var _down  = (_row < _rows - 1) && (tilemap_get(_tilemap, _col, _row + 1) != 0);
            var _left  = (_col > 0)        && (tilemap_get(_tilemap, _col - 1, _row) != 0);
            var _right = (_col < _cols - 1) && (tilemap_get(_tilemap, _col + 1, _row) != 0);

            array_push(wall_list, {
                wx: _col * 32,
                wy: _row * 32,
                up: _up,
                down: _down,
                left: _left,
                right: _right
            });
        } else {
            // Empty tile = walkable floor, remember it for plank drawing
            array_push(floor_list, {
                fx: _col * 32,
                fy: _row * 32,
                // Stagger seam offset by row so planks look offset like real wood
                seam_offset: (_row mod 2) * 16
            });
        }
    }
}
