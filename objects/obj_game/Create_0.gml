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

Walking()