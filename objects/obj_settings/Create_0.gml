// HUD draws in GUI space at native resolution so text stays crisp
// (camera view is 640x320 upscaled to 1366x768 — drawing fonts in
// camera space would bilinear-blur every glyph).
display_set_gui_size(1366, 768);

// Fonts are sized for the GUI (native pixel) space, so they render
// at their true rasterized resolution and look sharp.
// All fonts use Arial for reliable cross-device rendering.
// Sized for kid-friendly readability (medium-large).
//
// Glyph range 32..1279 covers basic Latin AND the full Cyrillic block
// (0x0400..0x04FF) -- that's what the Russian and Kazakh translations
// need. The atlas is bigger but still fine for a small game.
global.font_main  = font_add("Arial", 28, false, false, 32, 1279);
global.font_ui    = font_add("Arial", 34, true,  false, 32, 1279);
global.font_title = font_add("Arial", 66, true,  false, 32, 1279);

// Dialogue fonts -- same story, just larger sizes.
global.font_dialogue = font_add("Arial", 40, false, false, 32, 1279);
global.font_speaker  = font_add("Arial", 34, true,  false, 32, 1279);
global.font_option   = font_add("Arial", 36, true,  false, 32, 1279);

// Game state
global.paused = false;

// Language preference + translation table -- must come before any UI
// that might call tr() / tr_pick().
lang_init();

// Progress tracking
init_progress();

// Screen transition controller — persistent, survives all room changes
if (!instance_exists(obj_transition)) {
    instance_create_depth(0, 0, -20000, obj_transition);
}

// On-screen D-pad (persistent; self-hides on desktop until touch detected)
global.touch_right   = false;
global.touch_left    = false;
global.touch_up      = false;
global.touch_down    = false;
global.touch_pressed = false;
if (!instance_exists(obj_touch_dpad)) {
    instance_create_depth(0, 0, -19000, obj_touch_dpad);
}

// First-play tutorial tracking — persisted via INI
global.tutorial_shown_pushblock = false;
global.tutorial_shown_quiz      = false;
global.tutorial_shown_memory    = false;
global.tutorial_shown_speech    = false;

// --- AUDIO ---
// One-shot game start jingle
audio_play_sound(Game_Start, 1, false);

// Background music — looped, lower volume so it sits behind SFX
audio_play_sound(Background_Music, 0, true);
audio_sound_gain(Background_Music, 0.35, 0);
