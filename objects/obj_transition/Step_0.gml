// Fade OUT — going dark, then jump to target room
if (state == 1) {
    alpha += fade_speed;
    if (alpha >= 1) {
        alpha = 1;
        if (target_room != -1) {
            var _t = target_room;
            target_room = -1;
            room_goto(_t);
            // Queue a fade-in for the new room. room_goto is deferred,
            // so we set up the next state right here.
            state = 2;
        }
    }
}

// Fade IN — revealing the new room
if (state == 2) {
    alpha -= fade_speed;
    if (alpha <= 0) {
        alpha = 0;
        state = 0;
    }
}
