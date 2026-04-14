// Tiny footstep dust puff — 3 small circles that expand and fade.
// Spawn at the player's feet when a slide starts.
life     = 0;
life_max = 14;

puffs = [];
for (var i = 0; i < 3; i++) {
    array_push(puffs, {
        ox: random_range(-4, 4),
        oy: random_range(-2, 2),
        r:  random_range(2, 3.5),
    });
}
