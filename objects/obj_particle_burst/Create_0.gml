// Reusable particle burst — spawn with:
//   var _p = instance_create_depth(px, py, -5000, obj_particle_burst);
//   _p.burst_colour = c_lime;     // optional, default c_white
//   _p.burst_count  = 12;         // optional
//   _p.burst_speed  = 2.5;        // optional
//   _p.burst_life   = 24;         // optional (frames)
//   _p.burst_size   = 3;          // optional (starting radius)
//
// Each dot flies outward, shrinks, and fades. Self-destroys when done.

burst_colour = c_white;
burst_count  = 12;
burst_speed  = 2.5;
burst_life   = 24;
burst_size   = 3;

// Populated on first Step
dots = -1;
setup_done = false;
