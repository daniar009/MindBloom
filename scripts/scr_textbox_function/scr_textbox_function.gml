/// Dialogue helper functions

// Add a line of dialogue to the current textbox
// _speaker and _portrait are optional -- leave them out for narrator text
function scr_text(_text, _speaker = "", _portrait = -1) {
    text[page_number] = _text;
    speaker[page_number] = _speaker;
    portrait[page_number] = _portrait;
    page_number++;
}

// Add a clickable option that branches to another dialogue
function scr_option(_option, _link_id) {
    option[option_number] = _option;
    option_link_id[option_number] = _link_id;
    option_number++;
}

// Spawn a textbox and fill it with dialogue from the database
function create_textbox(_text_id) {
    with (instance_create_depth(0, 0, -9999, obj_textbox)) {
        scr_game_text(_text_id);
    }
}
