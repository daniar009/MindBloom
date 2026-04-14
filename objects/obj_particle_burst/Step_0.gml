// Deferred setup (so creation code can override vars first)
if (!setup_done) {
    setup_done = true;
    dots = array_create(burst_count);
    for (var i = 0; i < burst_count; i++) {
        var _angle = (360 / burst_count) * i + random_range(-15, 15);
        var _spd   = burst_speed * random_range(0.6, 1.4);
        dots[i] = {
            px: x,
            py: y,
            vx: lengthdir_x(_spd, _angle),
            vy: lengthdir_y(_spd, _angle),
            life: burst_life + irandom_range(-4, 4),
            life_max: burst_life,
            r: burst_size * random_range(0.7, 1.3),
        };
    }
}

// Update all dots
var _alive = false;
for (var i = 0; i < burst_count; i++) {
    var _d = dots[i];
    if (_d.life <= 0) continue;
    _alive = true;
    _d.px += _d.vx;
    _d.py += _d.vy;
    _d.vx *= 0.92;  // drag
    _d.vy *= 0.92;
    _d.vy += 0.06;  // gentle gravity
    _d.life--;
}

if (!_alive) instance_destroy();
