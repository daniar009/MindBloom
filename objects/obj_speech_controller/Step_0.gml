if (global.paused) exit;
if (instance_exists(obj_tutorial_overlay)) exit;

pulse_timer += 0.05;

// -----------------------------------------
// STATE 0 — READY: click mic button to start listening
// (mic + skip rects are cached by Draw GUI in GUI-space coords)
// -----------------------------------------
if (state == 0 && mouse_check_button_pressed(mb_left)) {
    var _gmx = device_mouse_x_to_gui(0);
    var _gmy = device_mouse_y_to_gui(0);
    var _dist = point_distance(_gmx, _gmy, mic_btn_x, mic_btn_y);

    // Tap the mic → start listening
    if (_dist <= mic_btn_r) {
        // Try every channel the OS exposes (some drivers number them oddly)
        var _mic_count = audio_get_recorder_count();
        show_debug_message("=== MIC START === audio_get_recorder_count = " + string(_mic_count));

        rec_buffer = -1;
        if (_mic_count > 0) {
            for (var _ch = 0; _ch < _mic_count; _ch++) {
                var _b = audio_start_recording(_ch);
                show_debug_message("  channel " + string(_ch) + " → buffer " + string(_b));
                if (_b != -1 && _b != undefined) {
                    rec_buffer  = _b;
                    rec_channel = _ch;
                    break;
                }
            }
        }

        // Reset state regardless of mic success — the HOLD fallback ALWAYS works
        rec_available   = (rec_buffer != -1);
        rec_read_pos    = 0;
        loud_frames     = 0;
        listen_timer    = 0;
        current_amplitude = 0;
        state = 1;

        if (rec_available) {
            show_debug_message("Listening for: " + words[word_index] + " (mic OK)");
        } else {
            show_debug_message("No working mic — HOLD mic button or SPACE to pass");
        }
    }

    // Skip button (only appears after 3 fails)
    if (skip_allowed) {
        if (_gmx >= skip_rect[0] && _gmx <= skip_rect[2]
         && _gmy >= skip_rect[1] && _gmy <= skip_rect[3]) {
            state = 2;
            solved = true;
            solve_timer = 60;
            show_debug_message("Player skipped this level");
        }
    }
}

// -----------------------------------------
// STATE 1 — LISTENING: scan new audio samples for amplitude
// -----------------------------------------
if (state == 1) {
    listen_timer++;

    // HOLD-TO-PASS fallback — always active. Three equivalent paths fill
    // the loud_frames meter:
    //   1. The microphone picks up sound above threshold (real vocalization)
    //   2. The player holds the SPACEBAR
    //   3. The player presses-and-HOLDS the left mouse button anywhere
    // Any of the three will eventually fill the bar in ~0.4s. This makes
    // the puzzle accessible for non-verbal kids, accommodates broken mics,
    // and guarantees demos never get stuck.
    if (keyboard_check(vk_space) || mouse_check_button(mb_left)) {
        loud_frames++;
        current_amplitude = max(current_amplitude, amplitude_threshold + 500);
    }

    // Periodic live-amplitude print so we can see what the mic is picking up.
    // Also reports whether the recording buffer is growing (the smoking gun
    // for "mic returned a buffer but no data is streaming in").
    debug_print_timer++;
    if (debug_print_timer >= 15) {
        debug_print_timer = 0;
        var _bsize = (rec_buffer != -1 && buffer_exists(rec_buffer))
                     ? buffer_get_size(rec_buffer) : -1;
        show_debug_message("amp=" + string(round(current_amplitude))
            + " loud=" + string(loud_frames) + "/" + string(loud_frames_needed)
            + " t=" + string(listen_timer)
            + " buf=" + string(_bsize) + " read=" + string(rec_read_pos));
    }

    // Read any new samples that have been recorded since last frame.
    // The buffer grows as audio data streams in.
    if (rec_buffer != -1 && buffer_exists(rec_buffer)) {
        var _size = buffer_get_size(rec_buffer);

        if (_size > rec_read_pos + 2) {
            buffer_seek(rec_buffer, buffer_seek_start, rec_read_pos);

            var _sum_sq   = 0;
            var _samples  = 0;

            // Read as 16-bit signed PCM samples
            while (buffer_tell(rec_buffer) <= _size - 2) {
                var _s = buffer_read(rec_buffer, buffer_s16);
                _sum_sq += (_s * _s);
                _samples++;
                // Safety cap — don't chew through megabytes per frame
                if (_samples >= 4096) break;
            }

            rec_read_pos = buffer_tell(rec_buffer);

            if (_samples > 0) {
                // RMS amplitude — better than raw avg for voice
                current_amplitude = sqrt(_sum_sq / _samples);
            }
        }

        // Above threshold? Count toward success.
        if (current_amplitude > amplitude_threshold) {
            loud_frames++;
        }
    }

    // Win check — lives OUTSIDE the buffer block so spacebar fallback works too
    if (loud_frames >= loud_frames_needed) {
        if (rec_buffer != -1) {
            audio_stop_recording(rec_channel);
            rec_buffer = -1;
        }
        fail_count = 0;
        state = 2;
        solved = true;
        solve_timer = 90;
        audio_play_sound(Correct_Answer_Vocalize, 3, false);
        audio_play_sound(Level_complete, 4, false);
        // Celebration particles at center of view
        var _cam_cx = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
        var _cam_cy = camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) / 2;
        var _p = instance_create_depth(_cam_cx, _cam_cy, -5000, obj_particle_burst);
        _p.burst_colour = make_colour_rgb(255, 220, 120);
        _p.burst_count = 16;
        camera_shake(2);
        show_debug_message("Vocalization detected — passing level");
    }

    // Out of time → timeout
    if (listen_timer >= listen_max) {
        if (rec_buffer != -1) {
            audio_stop_recording(rec_channel);
            rec_buffer = -1;
        }
        state = 3;
        feedback_timer = 90;
        fail_count++;
        if (fail_count >= 3) skip_allowed = true;
        show_debug_message("Listening timeout (fail #" + string(fail_count) + ")");
    }
}

// -----------------------------------------
// STATE 3 / 4 — cooldown then return to ready
// -----------------------------------------
if (state == 3 || state == 4) {
    feedback_timer--;
    if (feedback_timer <= 0) {
        state = 0;
    }
}

// -----------------------------------------
// CORRECT — advance after celebration delay
// -----------------------------------------
if (solved) {
    solve_timer--;
    if (solve_timer <= 0) {
        if (room == rm_speech_4) {
            global.puzzle_complete[3] = 1;
            update_house_stage();
            save_game();
            transition_to(Room1);
        } else {
            transition_to(room_next(room));
        }
    }
}

// -----------------------------------------
// Reset — keyboard R or on-screen reset button (mobile).
// Also stops any live recording.
// -----------------------------------------
if (keyboard_check_pressed(ord("R")) || global.touch_reset_pressed) {
    if (rec_buffer != -1) {
        audio_stop_recording(rec_channel);
        rec_buffer = -1;
    }
    state = 0;
    solved = false;
    feedback_timer = 0;
    loud_frames = 0;
    listen_timer = 0;
    current_amplitude = 0;
}
