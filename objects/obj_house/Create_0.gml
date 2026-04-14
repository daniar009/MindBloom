// House draws itself based on global.house_stage (0-4)
// Stage 0: Empty plot / foundation outline
// Stage 1: Foundation + wooden frame
// Stage 2: + Walls filled in
// Stage 3: + Roof
// Stage 4: Full house with door, windows, chimney

// Spawn the grass decoration controller (flowers, clovers, mushrooms,
// butterflies, etc). obj_house only lives in Room1, so this is a safe
// place to kick off the overworld dressing.
if (!instance_exists(obj_grass_decor)) {
    instance_create_depth(0, 0, 50, obj_grass_decor);
}

// Tracks whether the player is close enough to the door to enter.
// Flipped by the Step event, read by Draw_64 for the prompt.
near_door = false;
