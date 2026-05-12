// =========================================
// SAVE / LOAD SYSTEM
// =========================================

function save_game() {
    ini_open("savefile.ini");

    // Puzzle completion flags
    ini_write_real("progress", "puzzle_pushblock", global.puzzle_complete[0]);
    ini_write_real("progress", "puzzle_memory",    global.puzzle_complete[1]);
    ini_write_real("progress", "puzzle_quiz",      global.puzzle_complete[2]);
    ini_write_real("progress", "puzzle_speech",    global.puzzle_complete[3]);

    // House stage
    ini_write_real("progress", "house_stage", global.house_stage);

    // Best move counts per pushblock level (0 = unset)
    for (var i = 0; i < 4; i++) {
        ini_write_real("best", "pushblock_" + string(i), global.pushblock_best[i]);
    }

    // Language preference — kept alongside progress so it sticks
    if (variable_global_exists("language")) {
        ini_write_string("settings", "language", global.language);
    }

    ini_close();
    show_debug_message("Game saved.");
}

function load_game() {
    if (!file_exists("savefile.ini")) return false;

    ini_open("savefile.ini");

    global.puzzle_complete[0] = ini_read_real("progress", "puzzle_pushblock", 0);
    global.puzzle_complete[1] = ini_read_real("progress", "puzzle_memory",    0);
    global.puzzle_complete[2] = ini_read_real("progress", "puzzle_quiz",      0);
    global.puzzle_complete[3] = ini_read_real("progress", "puzzle_speech",    0);

    global.house_stage = ini_read_real("progress", "house_stage", 0);

    for (var i = 0; i < 4; i++) {
        global.pushblock_best[i] = ini_read_real("best", "pushblock_" + string(i), 0);
    }

    ini_close();
    show_debug_message("Game loaded.");
    return true;
}

function save_exists() {
    return file_exists("savefile.ini");
}

function delete_save() {
    // Keep the language preference across a "new game" wipe --
    // it's a UI setting, not progress, and resetting it is annoying.
    var _lang = variable_global_exists("language") ? global.language : "en";

    if (file_exists("savefile.ini")) {
        file_delete("savefile.ini");
    }

    ini_open("savefile.ini");
    ini_write_string("settings", "language", _lang);
    ini_close();

    show_debug_message("Save deleted.");
}

function init_progress() {
    // Puzzle completion: [pushblock, memory, quiz, speech]
    global.puzzle_complete = array_create(4, 0);
    global.house_stage = 0;
    global.pushblock_best = array_create(4, 0);  // 0 = no best yet

    // Reset first-play tutorial flags on a fresh game. Without this,
    // switching language via the title screen after playing through a
    // tutorial in one language would leave the flag true and the
    // tutorial would silently skip in the new language.
    global.tutorial_shown_pushblock = false;
    global.tutorial_shown_quiz      = false;
    global.tutorial_shown_memory    = false;
    global.tutorial_shown_speech    = false;
}

function update_house_stage() {
    // Count completed puzzles
    var _count = 0;
    for (var i = 0; i < 4; i++) {
        if (global.puzzle_complete[i]) _count++;
    }
    global.house_stage = _count;
}

// =========================================
// NPC CHECKMARK — draws a green checkmark above a completed NPC
// =========================================
function draw_npc_checkmark(_x, _y, _done) {
    if (!_done) return;

    // Bobbing animation
    var _bob = sin(current_time / 300) * 2;
    var _cx = _x + 16;
    var _cy = _y - 14 + _bob;
    var _r  = 9;

    // White outline circle (for contrast on any background)
    draw_set_colour(c_white);
    draw_circle(_cx, _cy, _r + 1, false);

    // Green circle background
    draw_set_colour(make_colour_rgb(60, 200, 90));
    draw_circle(_cx, _cy, _r, false);

    // Darker green border
    draw_set_colour(make_colour_rgb(40, 150, 60));
    draw_circle(_cx, _cy, _r, true);

    // White checkmark
    draw_set_colour(c_white);
    draw_line_width(_cx - 4, _cy,     _cx - 1, _cy + 3, 2);
    draw_line_width(_cx - 1, _cy + 3, _cx + 5, _cy - 3, 2);

    draw_set_colour(c_white);
}

// =========================================
// SCREEN SHAKE — call from anywhere to kick the camera
// Example: camera_shake(4) for a small thump, camera_shake(8) for a thud
// =========================================
// =========================================
// CAMERA KISS ZOOM — slight zoom-in for celebration moments
// Example: camera_zoom_kiss() on puzzle solve
// =========================================
function camera_zoom_kiss() {
    if (instance_exists(obj_camera_1)) {
        obj_camera_1.zoom_timer = obj_camera_1.zoom_duration;
    }
}

function camera_shake(_amount) {
    if (instance_exists(obj_camera_1)) {
        // Take the stronger of what's already happening and the new hit,
        // so multiple shakes in a row don't cancel each other out.
        obj_camera_1.shake_amount = max(obj_camera_1.shake_amount, _amount);
    }
}

// =========================================
// SCREEN TRANSITIONS — smooth fade between rooms
// =========================================
function transition_to(_target_room) {
    // Ask obj_transition to fade out and jump when it's fully black.
    // If the transition object isn't around for some reason, fall back
    // to a plain room_goto so the game still works.
    if (instance_exists(obj_transition)) {
        with (obj_transition) {
            state = 1;             // fade out
            target_room = _target_room;
        }
    } else {
        room_goto(_target_room);
    }
}

// =========================================
// LANGUAGE / LOCALIZATION
// Supports English ("en"), Russian ("ru"), Kazakh ("kk").
// Preference is stored in the same INI as game progress so the
// player's choice survives across sessions and new-game resets.
// =========================================

function lang_init() {
    // Read saved preference, defaulting to English on first run.
    if (file_exists("savefile.ini")) {
        ini_open("savefile.ini");
        global.language = ini_read_string("settings", "language", "en");
        ini_close();
    } else {
        global.language = "en";
    }
    lang_build_table();
}

function lang_set(_code) {
    global.language = _code;
    ini_open("savefile.ini");
    ini_write_string("settings", "language", _code);
    ini_close();
}

function lang_cycle() {
    // English -> Russian -> Kazakh -> English
    if      (global.language == "en") lang_set("ru");
    else if (global.language == "ru") lang_set("kk");
    else                              lang_set("en");
}

function lang_label() {
    if (global.language == "en") return "EN";
    if (global.language == "ru") return "RU";
    return "KZ";
}

// Look up a single string in the current language. Falls back to
// English if a key is missing from the active language table, and
// finally to the raw key so missing keys are visible in-game.
function tr(_key) {
    var _tbl;
    if      (global.language == "ru") _tbl = global.translations.ru;
    else if (global.language == "kk") _tbl = global.translations.kk;
    else                              _tbl = global.translations.en;

    if (variable_struct_exists(_tbl, _key)) {
        return variable_struct_get(_tbl, _key);
    }
    if (variable_struct_exists(global.translations.en, _key)) {
        return variable_struct_get(global.translations.en, _key);
    }
    return _key;
}

// Some keys store an array of variants (multiple phrasings of the
// same dialogue beat). tr_pick returns a random one each call, so
// NPCs don't say the exact same thing every single interaction.
function tr_pick(_key) {
    var _val = tr(_key);
    if (is_array(_val)) {
        var _len = array_length(_val);
        if (_len <= 0) return _key;
        return _val[irandom(_len - 1)];
    }
    return _val;
}

// For strings that embed a number -- e.g. "Moves: %N" or "%N/4
// puzzles". The translation contains a literal "%N" that gets
// swapped in for the value. Avoids having to rebuild each phrase
// with string concatenation per language (word order differs).
function tr_num(_key, _n) {
    return string_replace_all(tr(_key), "%N", string(_n));
}

// =========================================
// TRANSLATION TABLE
// One struct per language. Keys starting with npcN_ are per-NPC
// dialogue beats; arrays mean "pick one variant at random".
// =========================================
function lang_build_table() {
    global.translations = {
        // -------------------------------------------------
        // ENGLISH
        // -------------------------------------------------
        en: {
            // Character names
            name_maxwell: "Maxwell",
            name_mira:    "Mira",
            name_sage:    "Sage",
            name_echo:    "Echo",
            name_unknown: "???",

            // Title screen
            title_subtitle: "~ an adventure ~",
            title_new_game: "NEW GAME",
            title_continue: "CONTINUE",
            title_exit:     "EXIT",
            title_tap:      "tap to select",
            title_skip_all: "⭐ Skip to End",

            // House progress label
            house_puzzles: "%N/4 puzzles",
            house_done:    "Home Sweet Home!",

            // House interior
            house_enter_prompt:    "E - Enter home",
            interior_title:        "Your Cozy Home",
            interior_welcome:      "Welcome home!",
            interior_leave_prompt: "E - Leave home",
            interior_rug_label:    "Maxwell's favorite rug",
            interior_books_label:  "Sage's little library",
            interior_feather_label:"Mira's bright feather",
            interior_bell_label:   "Echo's little bell",
            interior_fire_label:   "The hearth glows warm.",
            interior_window_label: "A peaceful view.",
            interior_photo_label:  "Friends who helped you grow.",
            interior_sofa_label:   "A comfy reading spot.",
            interior_plant_label:  "You grew it yourself!",
            interior_cat_label:    "Maxwell naps, purring.",

            // Pause menu
            pause_title:    "PAUSED",
            pause_save:     "Save Game",
            pause_to_title: "To Title",
            pause_exit:     "Exit Game",
            pause_saved:    "Saved!",

            // Shared puzzle HUD
            hud_level:        "Level %N / 4",
            hud_moves:        "Moves: %N",
            hud_best:         "Best: %N",
            hud_restart:      "R - Restart",
            hud_undo:         "Z - Undo",
            hud_retry:        "R - Retry",
            hud_skip:         "Skip",
            hud_stuck:        "Stuck? Press R to restart or Z to undo",
            hud_solved:       "Puzzle Solved!",
            hud_moves_line:   "You did it in %N moves!",
            hud_best_suffix:  "(Best: %N)",
            hud_new_best:     "New best!",

            // Pushblock tutorial overlay
            tut_title:  "Push Puzzle!",
            tut_solved: "Solved!",
            tut_line1:  "Walk into a block to push it.",
            tut_line2:  "Push all blocks onto the glowing targets!",
            tut_line3:  "Press R to restart, Z to undo.",
            tut_start:  "Tap anywhere to start!",

            // Quiz puzzle
            quiz_prompt:  "What is this animal?",
            quiz_correct: "Correct!",

            // Memory puzzle
            memory_title:      "Match the Pairs!",
            memory_memorize:   "Memorize the cards...",
            memory_all_matched:"All Matched!",

            // Speech puzzle
            speech_title:           "Say the Word!",
            speech_tap:             "Tap and Speak",
            speech_listening:       "Listening...",
            speech_great:           "Great job!",
            speech_retry:           "Try again, a bit louder!",
            speech_mic_unavailable: "Microphone not available.",
            speech_check_perms:     "Check app permissions.",

            // Maxwell (NPC 1 -- pushblock)
            npc1_greet: [
                "Hello stranger meow!",
                "Meow meow, hi there!",
                "Oh! A visitor, nya~"
            ],
            npc1_name: [
                "My name is Maxwell nya.",
                "People call me Maxwell :3",
                "I'm Maxwell the cat!"
            ],
            npc1_intro: [
                "Nice to meet you :>",
                "So glad you came, purrr.",
                "I was just waiting for someone!"
            ],
            npc1_ask: [
                "Want to solve my purrzles?",
                "Want to play some purrzles with me?",
                "Would you help me with my purrzles?"
            ],
            npc1_yes: [
                "Meownificent!!!",
                "Purr~fect!",
                "Yesss, let's go nya!"
            ],
            npc1_no: [
                "Oh... :<",
                "Aww, okay. Come back meow.",
                "Mrrr... maybe next time."
            ],
            npc1_done_a: [
                "You already solved all my purrzles!",
                "Every purrzle, solved meow!",
                "No more purrzles left, nya~"
            ],
            npc1_done_b: [
                "You're a real puzzler nya~",
                "A true cat-detective!",
                "Purrrr... so clever."
            ],
            npc1_opt_yes: "Yes!",
            npc1_opt_no:  "No...",

            // Mira (NPC 2 -- memory)
            npc2_greet: [
                "Hey there, traveler!",
                "Oh hi! A new face!",
                "Hello, friend~"
            ],
            npc2_name: [
                "People call me Mira.",
                "I'm Mira, nice to meet you.",
                "Mira's the name!"
            ],
            npc2_intro: [
                "I collect memories... and sometimes I lose them.",
                "My memories keep scattering on me...",
                "I try to remember things, but the cards keep mixing up."
            ],
            npc2_ask: [
                "Wanna help me sort out my scattered cards?",
                "Could you match the pairs for me?",
                "Would you help me find the matches?"
            ],
            npc2_yes: [
                "Wonderful! Match the pairs to put them back!",
                "Yay! Flip two at a time!",
                "Thank you! Let's match them up!"
            ],
            npc2_no: [
                "That's okay... they're not going anywhere.",
                "No problem. Come back whenever.",
                "Alright, I'll wait."
            ],
            npc2_done_a: [
                "All my memories are back in order!",
                "Every card matched -- you did it!",
                "My memories are whole again!"
            ],
            npc2_done_b: [
                "Thanks to you, traveler~",
                "You're a true friend!",
                "I won't forget this!"
            ],
            npc2_opt_yes: "Sure!",
            npc2_opt_no:  "Not now.",

            // Sage (NPC 3 -- animal quiz)
            npc3_greet: [
                "Greetings, young wanderer.",
                "Ah, a curious soul approaches.",
                "Welcome, seeker of knowledge."
            ],
            npc3_name: [
                "They call me Sage.",
                "I am known as Sage.",
                "You may call me Sage."
            ],
            npc3_intro: [
                "I study the creatures of this world.",
                "I have spent years learning about animals.",
                "The creatures of the world are my passion."
            ],
            npc3_ask: [
                "Care to test your knowledge?",
                "Shall we see what you know?",
                "Would you like to study with me?"
            ],
            npc3_yes: [
                "Excellent! Name the creature I show you!",
                "Very well! Identify each one!",
                "Good. Tell me what you see."
            ],
            npc3_no: [
                "Knowledge can wait... but not forever.",
                "Very well. Return when ready.",
                "As you wish, wanderer."
            ],
            npc3_done_a: [
                "You know every creature by name now!",
                "You have learned them all.",
                "Nothing escapes your eye."
            ],
            npc3_done_b: [
                "A true scholar.",
                "Impressive, truly.",
                "The world is richer for your knowledge."
            ],
            npc3_opt_yes: "Let's go!",
            npc3_opt_no:  "Maybe later.",

            // Echo (NPC 4 -- speech)
            npc4_greet: [
                "...",
                "...hmm...",
                "...la la..."
            ],
            npc4_name: [
                "Oh! Sorry, I was practicing my pronunciation.",
                "Ah! I didn't notice you there.",
                "Oh, hello! Just warming up my voice."
            ],
            npc4_intro: [
                "I'm Echo. I teach words by listening!",
                "I'm Echo, and I love helping voices grow.",
                "Name's Echo. I listen to how you say things!"
            ],
            npc4_ask: [
                "I'll show you a word, and you say it into your mic. Want to try?",
                "Read a word out loud and I'll hear you. Ready?",
                "Just say the word clearly. Want to give it a go?"
            ],
            npc4_yes: [
                "Great! Speak clearly into your microphone!",
                "Wonderful! Nice and loud, please!",
                "Perfect! Take your time with each word."
            ],
            npc4_no: [
                "No worries. Come back when you find your voice!",
                "That's alright. Voices need time.",
                "Okay! I'll be here practicing."
            ],
            npc4_done_a: [
                "Your pronunciation is flawless now!",
                "Every word -- spoken beautifully!",
                "You speak so clearly now!"
            ],
            npc4_done_b: [
                "I have nothing left to teach you!",
                "You've outgrown my little lessons!",
                "Go share your voice with the world!"
            ],
            npc4_opt_yes: "Sure!",
            npc4_opt_no:  "Not now."
        },

        // -------------------------------------------------
        // RUSSIAN
        // -------------------------------------------------
        ru: {
            name_maxwell: "Максвелл",
            name_mira:    "Мира",
            name_sage:    "Сейдж",
            name_echo:    "Эхо",
            name_unknown: "???",

            title_subtitle: "~ приключение ~",
            title_new_game: "НОВАЯ ИГРА",
            title_continue: "ПРОДОЛЖИТЬ",
            title_exit:     "ВЫХОД",
            title_tap:      "нажмите для выбора",
            title_skip_all: "⭐ Пропустить всё",

            // House progress label
            house_puzzles: "Пазлы: %N/4",
            house_done:    "Дом, милый дом!",

            // House interior
            house_enter_prompt:    "E — Войти в дом",
            interior_title:        "Твой уютный дом",
            interior_welcome:      "С возвращением!",
            interior_leave_prompt: "E — Выйти",
            interior_rug_label:    "Любимый ковёр Максвелла",
            interior_books_label:  "Маленькая библиотека Сейджа",
            interior_feather_label:"Яркое пёрышко Миры",
            interior_bell_label:   "Колокольчик Эхо",
            interior_fire_label:   "Очаг тепло мерцает.",
            interior_window_label: "Тихий вид из окна.",
            interior_photo_label:  "Друзья, что помогли тебе вырасти.",
            interior_sofa_label:   "Уютное место для книги.",
            interior_plant_label:  "Ты вырастил его сам!",
            interior_cat_label:    "Максвелл дремлет и мурчит.",

            // Pause menu
            pause_title:    "ПАУЗА",
            pause_save:     "Сохранить",
            pause_to_title: "В меню",
            pause_exit:     "Выход",
            pause_saved:    "Сохранено!",

            // Shared puzzle HUD
            hud_level:        "Уровень %N / 4",
            hud_moves:        "Ходы: %N",
            hud_best:         "Лучший: %N",
            hud_restart:      "R - Заново",
            hud_undo:         "Z - Отменить",
            hud_retry:        "R - Заново",
            hud_skip:         "Пропустить",
            hud_stuck:        "Застрял? R — заново, Z — отменить",
            hud_solved:       "Пазл решён!",
            hud_moves_line:   "Ты справился за %N ходов!",
            hud_best_suffix:  "(Лучший: %N)",
            hud_new_best:     "Новый рекорд!",

            // Pushblock tutorial overlay
            tut_title:  "Пазл-толкач!",
            tut_solved: "Готово!",
            tut_line1:  "Подойди к блоку, чтобы его толкнуть.",
            tut_line2:  "Толкай все блоки на светящиеся метки!",
            tut_line3:  "R — заново, Z — отменить.",
            tut_start:  "Нажми, чтобы начать!",

            // Quiz puzzle
            quiz_prompt:  "Какое это животное?",
            quiz_correct: "Верно!",

            // Memory puzzle
            memory_title:      "Найди пары!",
            memory_memorize:   "Запомни карты...",
            memory_all_matched:"Все найдены!",

            // Speech puzzle
            speech_title:           "Скажи слово!",
            speech_tap:             "Нажми и говори",
            speech_listening:       "Слушаю...",
            speech_great:           "Молодец!",
            speech_retry:           "Попробуй ещё, чуть громче!",
            speech_mic_unavailable: "Микрофон недоступен.",
            speech_check_perms:     "Проверь разрешения приложения.",

            npc1_greet: [
                "Привет, незнакомец, мяу!",
                "Мяу-мяу, приветик!",
                "О! Гость, ня~"
            ],
            npc1_name: [
                "Меня зовут Максвелл, ня.",
                "Все зовут меня Максвелл :3",
                "Я кот Максвелл!"
            ],
            npc1_intro: [
                "Приятно познакомиться :>",
                "Как хорошо, что ты пришёл, мурр.",
                "Я как раз кого-то ждал!"
            ],
            npc1_ask: [
                "Хочешь порешать мои муррзлы?",
                "Поиграем в муррзлы вместе?",
                "Поможешь мне с муррзлами?"
            ],
            npc1_yes: [
                "Мяунифико!!!",
                "Пурр~фектно!",
                "Даааа, вперёд, ня!"
            ],
            npc1_no: [
                "Ох... :<",
                "Эх, ладно. Возвращайся, мяу.",
                "Мррр... может в другой раз."
            ],
            npc1_done_a: [
                "Ты уже решил все мои муррзлы!",
                "Все муррзлы -- решены, мяу!",
                "Муррзлов больше не осталось, ня~"
            ],
            npc1_done_b: [
                "Ты настоящий решала, ня~",
                "Прямо котик-детектив!",
                "Пурррр... такой умный."
            ],
            npc1_opt_yes: "Да!",
            npc1_opt_no:  "Нет...",

            npc2_greet: [
                "Привет, путник!",
                "Ой, новое лицо!",
                "Здравствуй, друг~"
            ],
            npc2_name: [
                "Меня зовут Мира.",
                "Я Мира, приятно познакомиться.",
                "Меня зовут Мира!"
            ],
            npc2_intro: [
                "Я собираю воспоминания... и иногда их теряю.",
                "Мои воспоминания всё время разлетаются...",
                "Пытаюсь всё запомнить, но карточки путаются."
            ],
            npc2_ask: [
                "Поможешь мне собрать разбросанные карточки?",
                "Подберёшь для меня пары?",
                "Поможешь мне найти совпадения?"
            ],
            npc2_yes: [
                "Прекрасно! Переворачивай пары, чтобы собрать их!",
                "Ура! Открывай по две за раз!",
                "Спасибо! Давай соберём их!"
            ],
            npc2_no: [
                "Ничего страшного... они никуда не денутся.",
                "Ладно. Приходи, когда захочешь.",
                "Хорошо, я подожду."
            ],
            npc2_done_a: [
                "Все мои воспоминания снова в порядке!",
                "Все карты собраны -- ты справился!",
                "Мои воспоминания снова целы!"
            ],
            npc2_done_b: [
                "Спасибо тебе, путник~",
                "Ты настоящий друг!",
                "Я этого не забуду!"
            ],
            npc2_opt_yes: "Давай!",
            npc2_opt_no:  "Не сейчас.",

            npc3_greet: [
                "Приветствую, юный странник.",
                "А, приближается любопытная душа.",
                "Добро пожаловать, искатель знаний."
            ],
            npc3_name: [
                "Меня зовут Сейдж.",
                "Я известен как Сейдж.",
                "Можешь звать меня Сейдж."
            ],
            npc3_intro: [
                "Я изучаю существ этого мира.",
                "Я много лет изучаю животных.",
                "Существа этого мира -- моя страсть."
            ],
            npc3_ask: [
                "Проверим твои знания?",
                "Посмотрим, что ты знаешь?",
                "Хочешь позаниматься со мной?"
            ],
            npc3_yes: [
                "Превосходно! Назови существо, которое я покажу!",
                "Хорошо! Определи каждого!",
                "Отлично. Расскажи, что видишь."
            ],
            npc3_no: [
                "Знания могут подождать... но не вечно.",
                "Хорошо. Возвращайся, когда будешь готов.",
                "Как пожелаешь, странник."
            ],
            npc3_done_a: [
                "Ты теперь знаешь каждое существо по имени!",
                "Ты выучил их всех.",
                "Ничто не ускользнёт от твоего взгляда."
            ],
            npc3_done_b: [
                "Истинный учёный.",
                "Впечатляюще, правда.",
                "Мир богаче благодаря твоим знаниям."
            ],
            npc3_opt_yes: "Начнём!",
            npc3_opt_no:  "Может позже.",

            npc4_greet: [
                "...",
                "...хмм...",
                "...ла-ла..."
            ],
            npc4_name: [
                "Ой! Извини, я тренировал произношение.",
                "А! Я тебя не заметил.",
                "О, привет! Я просто разогреваю голос."
            ],
            npc4_intro: [
                "Я Эхо. Учу словам на слух!",
                "Я Эхо, обожаю помогать голосам расти.",
                "Меня зовут Эхо. Я слушаю, как ты говоришь!"
            ],
            npc4_ask: [
                "Я покажу слово, а ты произнеси его в микрофон. Попробуешь?",
                "Прочитай слово вслух -- я услышу. Готов?",
                "Просто скажи слово чётко. Хочешь попробовать?"
            ],
            npc4_yes: [
                "Отлично! Говори чётко в микрофон!",
                "Прекрасно! Погромче, пожалуйста!",
                "Идеально! Не торопись с каждым словом."
            ],
            npc4_no: [
                "Ничего. Приходи, когда найдёшь свой голос!",
                "Хорошо. Голосу нужно время.",
                "Ладно! Я буду тренироваться."
            ],
            npc4_done_a: [
                "Твоё произношение теперь безупречное!",
                "Каждое слово -- произнесено красиво!",
                "Ты говоришь так чётко!"
            ],
            npc4_done_b: [
                "Мне больше нечему тебя учить!",
                "Ты перерос мои уроки!",
                "Иди, поделись голосом с миром!"
            ],
            npc4_opt_yes: "Давай!",
            npc4_opt_no:  "Не сейчас."
        },

        // -------------------------------------------------
        // KAZAKH
        // -------------------------------------------------
        kk: {
            name_maxwell: "Максвелл",
            name_mira:    "Мира",
            name_sage:    "Сейдж",
            name_echo:    "Эхо",
            name_unknown: "???",

            title_subtitle: "~ шытырман оқиға ~",
            title_new_game: "ЖАҢА ОЙЫН",
            title_continue: "ЖАЛҒАСТЫРУ",
            title_exit:     "ШЫҒУ",
            title_tap:      "таңдау үшін басыңыз",
            title_skip_all: "⭐ Барлығын өткізу",

            // House progress label
            house_puzzles: "Пазл: %N/4",
            house_done:    "Тәтті үй!",

            // House interior
            house_enter_prompt:    "E — Үйге кіру",
            interior_title:        "Сенің жайлы үйің",
            interior_welcome:      "Үйге қош келдің!",
            interior_leave_prompt: "E — Шығу",
            interior_rug_label:    "Максвеллдің сүйікті кілемі",
            interior_books_label:  "Сейдждің шағын кітапханасы",
            interior_feather_label:"Мираның жарқын қауырсыны",
            interior_bell_label:   "Эхоның қоңырауы",
            interior_fire_label:   "Пеш жылы жымыңдайды.",
            interior_window_label: "Тыныш көрініс.",
            interior_photo_label:  "Өсуіңе көмектескен достар.",
            interior_sofa_label:   "Кітап оқуға жайлы орын.",
            interior_plant_label:  "Оны өзің өсірдің!",
            interior_cat_label:    "Максвелл мырылдап ұйықтайды.",

            // Pause menu
            pause_title:    "КІДІРІС",
            pause_save:     "Сақтау",
            pause_to_title: "Мәзірге",
            pause_exit:     "Шығу",
            pause_saved:    "Сақталды!",

            // Shared puzzle HUD
            hud_level:        "Деңгей %N / 4",
            hud_moves:        "Қадамдар: %N",
            hud_best:         "Үздік: %N",
            hud_restart:      "R - Қайта",
            hud_undo:         "Z - Болдырмау",
            hud_retry:        "R - Қайта",
            hud_skip:         "Өткізу",
            hud_stuck:        "Тұрып қалдың ба? R — қайта, Z — болдырмау",
            hud_solved:       "Пазл шешілді!",
            hud_moves_line:   "Сен %N қадаммен шештің!",
            hud_best_suffix:  "(Үздік: %N)",
            hud_new_best:     "Жаңа рекорд!",

            // Pushblock tutorial overlay
            tut_title:  "Итермелі пазл!",
            tut_solved: "Шешілді!",
            tut_line1:  "Блокты итеру үшін оған жақында.",
            tut_line2:  "Барлық блоктарды жарық белгіге итер!",
            tut_line3:  "R — қайта, Z — болдырмау.",
            tut_start:  "Бастау үшін бас!",

            // Quiz puzzle
            quiz_prompt:  "Бұл қандай жануар?",
            quiz_correct: "Дұрыс!",

            // Memory puzzle
            memory_title:      "Жұптарды тап!",
            memory_memorize:   "Карталарды есте сақта...",
            memory_all_matched:"Барлығы табылды!",

            // Speech puzzle
            speech_title:           "Сөзді айт!",
            speech_tap:             "Бас та сөйле",
            speech_listening:       "Тыңдап жатырмын...",
            speech_great:           "Жарайсың!",
            speech_retry:           "Тағы бір рет, қаттырақ!",
            speech_mic_unavailable: "Микрофон қолжетімсіз.",
            speech_check_perms:     "Қолданба рұқсаттарын тексер.",

            npc1_greet: [
                "Сәлем, бейтаныс, мяу!",
                "Мяу-мяу, сәлеметсің бе!",
                "О! Қонақ, ня~"
            ],
            npc1_name: [
                "Менің атым Максвелл, ня.",
                "Мені Максвелл деп атайды :3",
                "Мен мысық Максвеллмін!"
            ],
            npc1_intro: [
                "Танысқаныма қуаныштымын :>",
                "Келгеніңе қуаныштымын, мурр.",
                "Мен біреуді күтіп отыр едім!"
            ],
            npc1_ask: [
                "Менің мурзлдарымды шешкің келе ме?",
                "Бірге мурзл ойнайық па?",
                "Мурзлдарыма көмектесесің бе?"
            ],
            npc1_yes: [
                "Мяунифика!!!",
                "Пурр~емше!",
                "Иәәә, кеттік, ня!"
            ],
            npc1_no: [
                "Оу... :<",
                "Эх, жарайды. Қайтып кел, мяу.",
                "Мррр... келесіде."
            ],
            npc1_done_a: [
                "Сен менің барлық мурзлдарымды шештің!",
                "Барлық мурзл -- шешілді, мяу!",
                "Мурзл қалмады, ня~"
            ],
            npc1_done_b: [
                "Сен нағыз шешуші, ня~",
                "Нағыз мысық-детектив!",
                "Пурррр... қандай ақылды."
            ],
            npc1_opt_yes: "Иә!",
            npc1_opt_no:  "Жоқ...",

            npc2_greet: [
                "Сәлем, саяхатшы!",
                "Ой, жаңа бет!",
                "Сәлеметсің бе, дос~"
            ],
            npc2_name: [
                "Менің атым Мира.",
                "Мен Мирамын, танысқаныма қуаныштымын.",
                "Менің атым -- Мира!"
            ],
            npc2_intro: [
                "Мен естеліктерді жинаймын... кейде оларды жоғалтамын.",
                "Менің естеліктерім шашылып кетіп жатыр...",
                "Есте сақтауға тырысамын, бірақ карталар шатасып кетеді."
            ],
            npc2_ask: [
                "Шашылған карталарымды жинауға көмектесесің бе?",
                "Менің орнына жұптарды тауып бересің бе?",
                "Сәйкестіктерді табуға көмектесесің бе?"
            ],
            npc2_yes: [
                "Керемет! Жұптарды сәйкестендіріп, орнына қой!",
                "Уау! Екеуін бір уақытта аш!",
                "Рахмет! Бірге сәйкестендірейік!"
            ],
            npc2_no: [
                "Ештеңе етпейді... олар еш жерге кетпейді.",
                "Мәселе емес. Қашан қаласаң, кел.",
                "Жарайды, мен күтемін."
            ],
            npc2_done_a: [
                "Барлық естеліктерім қайта ретке келді!",
                "Барлық карта сәйкес -- сен жасадың!",
                "Естеліктерім қайта толық!"
            ],
            npc2_done_b: [
                "Саған рахмет, саяхатшы~",
                "Сен шынайы досым!",
                "Мен мұны ұмытпаймын!"
            ],
            npc2_opt_yes: "Әрине!",
            npc2_opt_no:  "Қазір емес.",

            npc3_greet: [
                "Сәлем, жас саяхатшы.",
                "Ә, әуесқой жан жақындап келе жатыр.",
                "Қош келдің, білім іздеуші."
            ],
            npc3_name: [
                "Мені Сейдж деп атайды.",
                "Мен Сейдж ретінде танымалмын.",
                "Мені Сейдж деп ата."
            ],
            npc3_intro: [
                "Мен осы әлемнің жаратылыстарын зерттеймін.",
                "Жануарларды көп жыл үйреніп келемін.",
                "Әлемнің жаратылыстары -- менің құмарлығым."
            ],
            npc3_ask: [
                "Біліміңді тексерейік пе?",
                "Не білетініңді көрейік пе?",
                "Менімен бірге оқығың келе ме?"
            ],
            npc3_yes: [
                "Тамаша! Мен көрсеткен жаратылысты ата!",
                "Жақсы! Әрқайсысын анықта!",
                "Жарайды. Не көргеніңді айт."
            ],
            npc3_no: [
                "Білім күте алады... бірақ мәңгі емес.",
                "Жарайды. Дайын болғанда кел.",
                "Қалағаныңдай, саяхатшы."
            ],
            npc3_done_a: [
                "Енді әр жаратылысты атымен білесің!",
                "Сен олардың бәрін үйрендің.",
                "Көзіңнен ештеңе қашпайды."
            ],
            npc3_done_b: [
                "Нағыз ғалым.",
                "Шынымен әсерлі.",
                "Әлем сенің біліміңмен байыды."
            ],
            npc3_opt_yes: "Кеттік!",
            npc3_opt_no:  "Кейінірек.",

            npc4_greet: [
                "...",
                "...ммм...",
                "...ла-ла..."
            ],
            npc4_name: [
                "Ой! Кешір, мен дыбыстауды жаттықтырып жатқам.",
                "Ә! Сені байқамадым.",
                "О, сәлем! Дауысымды қыздырып жатырмын."
            ],
            npc4_intro: [
                "Мен Эхомын. Сөздерді тыңдап үйретемін!",
                "Мен Эхомын, дауыстарға көмектескенді ұнатамын.",
                "Атым Эхо. Қалай сөйлегеніңді тыңдаймын!"
            ],
            npc4_ask: [
                "Мен сөз көрсетемін, сен оны микрофонға айтасың. Көресің бе?",
                "Сөзді дауыстап оқы -- мен естимін. Дайынсың ба?",
                "Сөзді айқын айтсаң болды. Көрейік пе?"
            ],
            npc4_yes: [
                "Керемет! Микрофонға айқын сөйле!",
                "Тамаша! Қаттырақ, өтінемін!",
                "Керемет! Әр сөзге асықпа."
            ],
            npc4_no: [
                "Мәселе жоқ. Дауысыңды тапқан соң кел!",
                "Жарайды. Дауысқа уақыт керек.",
                "Жақсы! Мен осында жаттығамын."
            ],
            npc4_done_a: [
                "Сенің дыбыстауың енді мінсіз!",
                "Әрбір сөз - әдемі айтылды!",
                "Енді сен өте айқын сөйлейсің!"
            ],
            npc4_done_b: [
                "Саған үйрететін ештеңем қалмады!",
                "Сен менің кішкентай сабақтарымнан асып түстің!",
                "Дауысыңды әлеммен бөліс!"
            ],
            npc4_opt_yes: "Әрине!",
            npc4_opt_no:  "Қазір емес."
        }
    };
}
