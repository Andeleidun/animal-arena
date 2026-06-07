input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));

SCREEN_START = 0;
SCREEN_CHOOSE_FIGHTER = 1;
SCREEN_OPTIONS = 2;
SCREEN_ACHIEVEMENTS = 3;
SCREEN_BATTLE = 4;

screen_state = SCREEN_START
chosen_animal = "none";

// Networking
network_type = "none"; // "host", "client", "none"
server_socket = -1;
client_socket = -1;
connected_socket = -1;
opponent_animal = "";
game_started = false;

// Network constants
PORT = 6510;
opponent_ready = false;
my_ready = false;

// UI state for dropdowns
show_host_dropdown = false;
show_join_dropdown = false;
lobby_code = "";
join_code = "";
host_code = "1234"; // Default code
lobby_created = false;
// Networking hosting state
connected_clients = 0;
max_clients = 2;
host_full = false;

// Ability system
ability_type = "";
ability_name = "";
ability_desc = "";
ability_duration = 0;
ability_cooldown = 0;
ability_active = false;
ability_timer = 0;
ability_cooldown_timer = 0;
mind_control_active = false;

// Projectile system (Barthemus)
projectile_active = false;
projectile_x = 0;
projectile_y = 0;
projectile_hspeed = 0;
projectile_vspeed = 0;
projectile_owner = noone;
projectile_loops = 0;
projectile_max_loops = 1;
projectile_shield_timer = 0;

// Poison dart system (Thorn)
poison_dart_active = false;
poison_dart_x = 0;
poison_dart_y = 0;
poison_dart_hspeed = 0;
poison_dart_vspeed = 0;
poison_dart_owner = noone;
poison_dart_loops = 0;
poison_dart_max_loops = 1;

// Achievements
achiev_count = 11;
achiev_search = "";
achiev_focused = false;
achiev_id = 0;  // for scrolling

achiev_name[0] = "Too Slow!";
achiev_desc[0] = "Hit an opponent then loop around the edge to dodge them attacking back 3 times";
achiev_loop_req[0] = 3;
achiev_unlocked[0] = false;
achiev_claimed[0] = false;

achiev_name[1] = "Stay Down";
achiev_desc[1] = "Hit a slowed opponent 5 times before the slow expires";
achiev_slow_req[1] = 5;
achiev_unlocked[1] = false;
achiev_claimed[1] = false;

achiev_name[2] = "Down to Earth";
achiev_desc[2] = "Land a hit within 60 frames of the opponent wrapping around the screen";
achiev_dte_req[2] = 3;
achiev_unlocked[2] = false;
achiev_claimed[2] = false;

achiev_name[3] = "Over Here!";
achiev_desc[3] = "Activate Gravity Field and land 3 swings without being hit before it ends";
achiev_over_here_req[3] = 3;
achiev_unlocked[3] = false;
achiev_claimed[3] = false;

// Tracking for Too Slow!
achiev_hit_just_now = 0;   // frames since last hit
achiev_edge_loops = 0;     // loops after a hit

// Tracking for Stay Down
achiev_slow_hits = 0;

// Tracking for Down to Earth
achiev_dte_timer = 0;
achiev_dte_hits = 0;

// Tracking for Over Here!
achiev_over_here_active = false;
achiev_over_here_swings = 0;
achiev_over_here_broken = false;

achiev_name[4] = "Back Again";
achiev_desc[4] = "Hit an opponent, wrap around the edge, then hit them again";
achiev_back_req[4] = 1;
achiev_unlocked[4] = false;
achiev_claimed[4] = false;

// Tracking for Back Again
achiev_back_hit = false;    // set true when hit lands
achiev_back_wrapped = false; // set true when wrap after hit

// Frog achievements
achiev_name[5] = "Toxic Touch";
achiev_desc[5] = "Deal 50 poison damage with Dart Frog's spit";
achiev_unlocked[5] = false;
achiev_claimed[5] = false;
achiev_frog_toxic_req = 50;

achiev_name[6] = "Stomper";
achiev_desc[6] = "Deal 100 damage with Bullfrog's Body Slam";
achiev_unlocked[6] = false;
achiev_claimed[6] = false;
achiev_frog_stomp_req = 100;

achiev_name[7] = "Leap Frog";
achiev_desc[7] = "Hit enemies 10 times with tongue shot as Tree Frog";
achiev_unlocked[7] = false;
achiev_claimed[7] = false;
achiev_frog_leap_req = 10;

achiev_name[8] = "Crystal Clear";
achiev_desc[8] = "Land 5 boosted tongue shots from Glass Frog's Refraction";
achiev_unlocked[8] = false;
achiev_claimed[8] = false;
achiev_frog_crystal_req = 5;

// 9 is unused/reserved

achiev_name[10] = "Chameleon";
achiev_desc[10] = "Catch a Thorn poison dart with Pond Frog's Croak";
achiev_unlocked[10] = false;
achiev_claimed[10] = false;

// Achievement toast
achiev_toast_text = "";
achiev_toast_timer = 0;
for (var _ati = 0; _ati < achiev_count; _ati++) achiev_toast_prev[_ati] = false;

// Breadcrumb system (Bread Duck)
breadcrumb_active = false;
breadcrumb_x = 0;
breadcrumb_y = 0;
breadcrumb_timer = 0;

// Frog projectile system (Dart Frog poison spit)
frog_projectile_active = false;
frog_projectile_x = 0;
frog_projectile_y = 0;
frog_projectile_hspeed = 0;
frog_projectile_vspeed = 0;
frog_projectile_owner = noone;

// Frog achievement tracking
achiev_frog_tongue_hits = 0;    // for Leap Frog
achiev_frog_poison_dmg = 0;     // for Toxic Touch
achiev_frog_slam_dmg = 0;       // for Stomper
achiev_frog_refract_hits = 0;   // for Crystal Clear
achiev_frog_croak_catch = 0;    // for Chameleon

// Sprig slingshot system
sprig_slingshot_active = false;
sprig_slingshot_x = 0;
sprig_slingshot_y = 0;
sprig_slingshot_hspeed = 0;
sprig_slingshot_vspeed = 0;
sprig_slingshot_owner = noone;
sprig_slingshot_loops = 0;
sprig_slingshot_max_loops = 1;

// Sprig fling tracking
sprig_fling_victim = noone;
sprig_fling_start_x = 0;
sprig_fling_start_y = 0;

// Practice mode
practice_menu_open = false;
practice_all_mode = true;
practice_context_duck = noone;
practice_controlled_duck = noone;
practice_cursor_type = "";
practice_cursor_sprite = -1;
practice_cursor_count = 0;
paused = false;

// Battle result
local_player_id = noone;
battle_over = false;
battle_result = "";
battle_text_y = -200;
battle_phase = "falling";
battle_hold_timer = 0;
battle_fade_alpha = 0;
rematch_ready = false;

Walking()