bob_timer += 0.08;

// Dismiss on any click
if (dismiss_on_click && mouse_check_button_pressed(mb_left)) {
    instance_destroy();
}
