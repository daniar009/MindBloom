// =========================================
// SPEECH PUZZLE — native mic amplitude detection
// =========================================
// No cloud, no Python, no internet needed. We simply measure how
// loud the child is speaking into the microphone. If they vocalize
// for ~0.5s total, the level passes.
//
// Pedagogical note: this rewards ANY vocalization, not just
// perfectly pronounced words — ideal for kids with speech delays.
// =========================================

// Which word to practice — set by room for reliability
word_index = 0;
if      (room == rm_speech_2) word_index = 1;
else if (room == rm_speech_3) word_index = 2;
else if (room == rm_speech_4) word_index = 3;

// Words for each level
words[0] = "apple";
words[1] = "elephant";
words[2] = "butterfly";
words[3] = "crocodile";

// Hint text shown below the word
hints[0] = "A round red fruit";
hints[1] = "A big grey animal with a trunk";
hints[2] = "A colorful insect with wings";
hints[3] = "A long green reptile with big teeth";

// -----------------------------------------
// STATE MACHINE
// 0 = waiting to start (click mic button)
// 1 = listening (recording + measuring amplitude)
// 2 = correct — vocalization detected
// 3 = timeout — no sound detected
// 4 = error — mic not available
// -----------------------------------------
state = 0;

feedback_timer = 0;
solve_timer    = 0;
solved         = false;
pulse_timer    = 0;

// -----------------------------------------
// RECORDING STATE
// -----------------------------------------
rec_channel        = 0;     // which mic input channel
rec_buffer         = -1;    // -1 = not recording
rec_read_pos       = 0;     // last byte we've scanned in the buffer
rec_available      = true;  // set false if audio_start_recording fails

// -----------------------------------------
// AMPLITUDE DETECTION
// -----------------------------------------
current_amplitude   = 0;     // latest RMS-ish reading for the volume meter
amplitude_threshold = 1200;  // how loud counts as "speaking" (forgiving for soft voices)
loud_frames         = 0;     // frames above threshold this attempt
loud_frames_needed  = 24;    // ~0.4s at 60fps — easier for kids who pause mid-word
listen_timer        = 0;     // total frames we've been listening
listen_max          = 360;   // 6 seconds max per attempt before timeout

// Failed attempts counter — after 3 strikes, offer a skip button
fail_count = 0;
skip_allowed = false;

// On Android, the RECORD_AUDIO permission must be granted at runtime
// (the manifest declaration alone is not sufficient on Android 6+).
// Request it here — the OS will show its own dialog the first time.
// If the parent declines, the spacebar / hold-anywhere fallback in
// Step_0 keeps the puzzle completable.
if (os_type == os_android) {
    try {
        os_permission_request("android.permission.RECORD_AUDIO");
    } catch (_err) {
        show_debug_message("os_permission_request failed: " + string(_err));
    }
}

// First-play tutorial overlay
if (room == rm_speech_1 && !global.tutorial_shown_speech) {
    global.tutorial_shown_speech = true;
    var _h = instance_create_depth(0, 0, -30000, obj_tutorial_overlay);
    _h.tut_type = "speech";
}

// Layout rects (set by Draw GUI each frame, used by Step click)
mic_btn_x = 0;
mic_btn_y = 0;
mic_btn_r = 0;
skip_rect = [0, 0, 0, 0];

// Debug amplitude print cadence (every N frames while listening)
debug_print_timer = 0;
