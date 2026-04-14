// Set by the controller when spawning
card_id    = 0;       // which pair this card belongs to (0, 1, 2, ...)
card_w     = 48;
card_h     = 64;

// State
flipped    = false;   // true when face is showing
matched    = false;   // true when pair is found
flip_timer = 0;       // animation timer (0 to 1)
flip_dir   = 0;       // 1 = flipping up, -1 = flipping back down
peek_card  = false;   // true while in level-start peek window
match_glow = 0;       // green-glow countdown after a match
miss_flash = 0;       // gentle red flash after a mismatch

// Colors for different card IDs (up to 10 unique symbols)
card_colours = [
    make_colour_rgb(220, 60,  60),   // red
    make_colour_rgb(60,  140, 220),  // blue
    make_colour_rgb(60,  200, 80),   // green
    make_colour_rgb(240, 180, 40),   // gold
    make_colour_rgb(180, 60,  200),  // purple
    make_colour_rgb(220, 120, 60),   // orange
    make_colour_rgb(60,  210, 200),  // teal
    make_colour_rgb(200, 200, 60),   // yellow
    make_colour_rgb(160, 100, 80),   // brown
    make_colour_rgb(220, 100, 160),  // pink
];

// Symbols drawn on each card (simple shapes via text)
card_symbols = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];
