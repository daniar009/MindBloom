// Which animal to show (set by instance creation code: 0..3)
question_index = 0;

// Animal names — index also picks which picture Draw renders
quiz_animal = ["Cat", "Elephant", "Penguin", "Octopus"];

// Larger distractor pool per animal — we pick 3 random wrong answers
// per attempt, mix in the correct one, and shuffle. This kills the
// "always click button #2" learned-bias bug.
quiz_distractors[0] = ["Dog",       "Bird",  "Fish",     "Rabbit",  "Mouse",  "Hamster", "Turtle"];
quiz_distractors[1] = ["Horse",     "Bear",  "Lion",     "Giraffe", "Rhino",  "Hippo",   "Zebra"];
quiz_distractors[2] = ["Duck",      "Owl",   "Eagle",    "Parrot",  "Swan",   "Robin",   "Crow"];
quiz_distractors[3] = ["Jellyfish", "Crab",  "Squid",    "Shrimp",  "Lobster","Starfish","Clam"];

// Display state — populated by build_question()
display_choices       = ["", "", "", ""];
display_correct_index = 0;

// State
selected       = -1;
correct        = false;
wrong          = false;
feedback_timer = 0;
solved         = false;
solve_timer    = 0;

// Fail tracking — show "Skip" after a few wrong tries
fail_count   = 0;
skip_allowed = false;

// Button grid rect (recomputed in Draw GUI each frame, used by Step click)
btn_grid_x   = 0;
btn_grid_y   = 0;
btn_grid_w   = 0;
btn_grid_h   = 0;
btn_grid_gap = 0;

// Skip button rect (GUI-space, recomputed each Draw)
skip_rect = [0, 0, 0, 0];

// --- Build a fresh shuffled question for the current animal ---
build_question = function() {
    var _correct_word = quiz_animal[question_index];
    var _pool = quiz_distractors[question_index];

    // Copy pool so we can pick without replacement
    var _bag = array_create(array_length(_pool));
    array_copy(_bag, 0, _pool, 0, array_length(_pool));

    // Pick 3 distractors
    var _picked = ["", "", ""];
    for (var i = 0; i < 3; i++) {
        var _idx = irandom(array_length(_bag) - 1);
        _picked[i] = _bag[_idx];
        array_delete(_bag, _idx, 1);
    }

    // Combine + shuffle
    var _all = [_correct_word, _picked[0], _picked[1], _picked[2]];
    for (var i = 3; i > 0; i--) {
        var _j = irandom(i);
        var _tmp = _all[i];
        _all[i]  = _all[_j];
        _all[_j] = _tmp;
    }

    display_choices = _all;
    for (var i = 0; i < 4; i++) {
        if (display_choices[i] == _correct_word) {
            display_correct_index = i;
            break;
        }
    }
};

// Set question based on which quiz room we're in
// (Creation code runs AFTER Create_0, so build_question() would use
// the wrong index if we relied on creation code alone.)
if      (room == rm_quiz_2) question_index = 1;
else if (room == rm_quiz_3) question_index = 2;
else if (room == rm_quiz_4) question_index = 3;

build_question();

// First-play tutorial overlay
if (room == rm_quiz_1 && !global.tutorial_shown_quiz) {
    global.tutorial_shown_quiz = true;
    var _h = instance_create_depth(0, 0, -30000, obj_tutorial_overlay);
    _h.tut_type = "quiz";
}
