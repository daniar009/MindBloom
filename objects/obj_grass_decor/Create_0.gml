// Scatters cute decorations across Room1: flowers, clovers, mushrooms,
// pebbles, grass tufts, and a handful of wandering butterflies.
//
// Everything is drawn with primitives — no sprite work needed — and the
// placement is seeded so it looks the same every visit.

room_w = room_width;
room_h = room_height;

// Don't clutter the ground around NPCs, the player spawn, or the house plot.
// (x, y, radius) — decorations inside these circles get rejected.
exclusion_zones = [
    [96,  832, 80],   // NPC 1
    [832, 832, 80],   // NPC 2
    [96,  64,  80],   // NPC 3
    [832, 64,  80],   // NPC 4
    [512, 576, 60],   // player spawn
    [416, 416, 160],  // house plot
];

// Deterministic scatter
random_set_seed(20260415);

decor = [];  // each entry: [kind, x, y, variant, sway_phase]

// kind 0 = flower, 1 = clover, 2 = pebble, 3 = mushroom, 4 = grass tuft, 5 = leaf

var _try_place = function(_kind, _count, _min_edge) {
    var _placed = 0;
    var _attempts = 0;
    while (_placed < _count && _attempts < _count * 20) {
        _attempts++;
        var _x = irandom_range(_min_edge, room_w - _min_edge);
        var _y = irandom_range(_min_edge, room_h - _min_edge);

        var _ok = true;
        for (var i = 0; i < array_length(exclusion_zones); i++) {
            var _z = exclusion_zones[i];
            if (point_distance(_x, _y, _z[0], _z[1]) < _z[2]) {
                _ok = false;
                break;
            }
        }
        if (!_ok) continue;

        array_push(decor, [_kind, _x, _y, irandom(3), random(2 * pi)]);
        _placed++;
    }
};

_try_place(0, 45, 20);  // flowers
_try_place(1, 30, 20);  // clovers
_try_place(2, 25, 20);  // pebbles
_try_place(3, 10, 20);  // mushrooms
_try_place(4, 55, 20);  // grass tufts
_try_place(5, 18, 20);  // leaves
_try_place(6, 700, 4); // fuzz (grass texture specks)

// --- Butterflies ---
// Each: {x, y, base_x, base_y, phase_a, phase_b, speed, colour, wing}
butterflies = [];
for (var i = 0; i < 5; i++) {
    var _bx, _by, _tries = 0, _ok = false;
    while (_tries < 40 && !_ok) {
        _tries++;
        _bx = irandom_range(80, room_w - 80);
        _by = irandom_range(80, room_h - 80);
        _ok = true;
        for (var j = 0; j < array_length(exclusion_zones); j++) {
            var _z = exclusion_zones[j];
            if (point_distance(_bx, _by, _z[0], _z[1]) < _z[2] + 20) {
                _ok = false;
                break;
            }
        }
    }

    var _colours = [
        make_colour_rgb(255, 180, 220),  // pink
        make_colour_rgb(255, 240, 140),  // butter yellow
        make_colour_rgb(180, 220, 255),  // sky
        make_colour_rgb(255, 200, 160),  // peach
        make_colour_rgb(220, 180, 255),  // lavender
    ];

    array_push(butterflies, {
        base_x : _bx,
        base_y : _by,
        x      : _bx,
        y      : _by,
        phase_a: random(2 * pi),
        phase_b: random(2 * pi),
        radius : random_range(40, 90),
        speed  : random_range(0.010, 0.020),
        colour : _colours[irandom(array_length(_colours) - 1)],
        wing_t : random(2 * pi),
    });
}

// Slight breeze phase for global sway of tufts/flowers
breeze_t = 0;

// Draw above ground tiles (depth 300) but behind walking entities
depth = 50;
