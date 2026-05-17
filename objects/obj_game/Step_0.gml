/// @description Networking step and input handling
if (network_type == "host" || network_type == "client")
{
    // Send chosen animal when it changes
    if (chosen_animal != "" && !game_started)
    {
        var buffer = buffer_create(256, buffer_fixed, 1);
        buffer_write(buffer, buffer_string, "animal:" + chosen_animal);
        if (network_type == "host" && client_socket != -1)
        {
            network_send_packet(client_socket, buffer, buffer_tell(buffer));
        }
        else if (network_type == "client" && client_socket != -1)
        {
            network_send_packet(client_socket, buffer, buffer_tell(buffer));
        }
        buffer_delete(buffer);
    }
}

// Handle keyboard input for join code
if (show_join_dropdown)
{
    // Use edge-triggered input to avoid holding digits
    if (keyboard_check_pressed(ord("0"))) { if (string_length(join_code) < 4) join_code += "0"; }
    if (keyboard_check_pressed(ord("1"))) { if (string_length(join_code) < 4) join_code += "1"; }
    if (keyboard_check_pressed(ord("2"))) { if (string_length(join_code) < 4) join_code += "2"; }
    if (keyboard_check_pressed(ord("3"))) { if (string_length(join_code) < 4) join_code += "3"; }
    if (keyboard_check_pressed(ord("4"))) { if (string_length(join_code) < 4) join_code += "4"; }
    if (keyboard_check_pressed(ord("5"))) { if (string_length(join_code) < 4) join_code += "5"; }
    if (keyboard_check_pressed(ord("6"))) { if (string_length(join_code) < 4) join_code += "6"; }
    if (keyboard_check_pressed(ord("7"))) { if (string_length(join_code) < 4) join_code += "7"; }
    if (keyboard_check_pressed(ord("8"))) { if (string_length(join_code) < 4) join_code += "8"; }
    if (keyboard_check_pressed(ord("9"))) { if (string_length(join_code) < 4) join_code += "9"; }
    if (keyboard_check_pressed(vk_backspace) && string_length(join_code) > 0)
    {
        join_code = string_copy(join_code, 1, string_length(join_code) - 1);
    }
}

// Handle keyboard input for host code
if (show_host_dropdown && !host_full)
{
    if (keyboard_check_pressed(ord("0"))) { if (string_length(host_code) < 4) host_code += "0"; }
    if (keyboard_check_pressed(ord("1"))) { if (string_length(host_code) < 4) host_code += "1"; }
    if (keyboard_check_pressed(ord("2"))) { if (string_length(host_code) < 4) host_code += "2"; }
    if (keyboard_check_pressed(ord("3"))) { if (string_length(host_code) < 4) host_code += "3"; }
    if (keyboard_check_pressed(ord("4"))) { if (string_length(host_code) < 4) host_code += "4"; }
    if (keyboard_check_pressed(ord("5"))) { if (string_length(host_code) < 4) host_code += "5"; }
    if (keyboard_check_pressed(ord("6"))) { if (string_length(host_code) < 4) host_code += "6"; }
    if (keyboard_check_pressed(ord("7"))) { if (string_length(host_code) < 4) host_code += "7"; }
    if (keyboard_check_pressed(ord("8"))) { if (string_length(host_code) < 4) host_code += "8"; }
    if (keyboard_check_pressed(ord("9"))) { if (string_length(host_code) < 4) host_code += "9"; }
    if (keyboard_check_pressed(vk_backspace) && string_length(host_code) > 0)
    {
        host_code = string_copy(host_code, 1, string_length(host_code) - 1);
    }
}

// Close dropdowns when clicking elsewhere
if (mouse_check_button_pressed(mb_left))
{
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Check if click is outside host dropdown
    // Expand the closable area to accommodate all host dropdown controls (including Start/Cancel)
    if (show_host_dropdown && (mx < 373 || mx > 727 || my < 142 || my > 260))
    {
        show_host_dropdown = false;
    }
    
    // Check if click is outside join dropdown
    // Expand closable area to cover Connect button and input area
    if (show_join_dropdown && (mx < 533 || mx > 687 || my < 142 || my > 260))
    {
        show_join_dropdown = false;
    }
}


	if (screen_state == SCREEN_BATTLE)
	{
    if (!instance_exists(obj_player))
    {
        instance_create_layer(500,360,"Instances",obj_player);
    }
	}
	
	input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));

Walking();