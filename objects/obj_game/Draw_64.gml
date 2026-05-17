//Start Screen
if screen_state == SCREEN_START
{
    draw_set_colour(c_navy);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1);

    // Title with shadow
    draw_set_colour(c_dkgray);
    draw_set_font(Font1);
    draw_text(440, 120, "Animal Arena!");
    
    draw_set_colour(c_white);
    draw_set_font(Font1);
    draw_text(446, 117, "Animal Arena!");

    if (ui_button(446, 317, 325, 108, "Play"))
    {
        screen_state = SCREEN_CHOOSE_FIGHTER;
    }

    if (ui_button(446, 450, 325, 108, "Settings"))
    {
        screen_state = SCREEN_OPTIONS;
    }

    if (ui_button(446, 588, 325, 108, "Achievements"))
    {
        screen_state = SCREEN_ACHIEVEMENTS;
    }

    if (ui_button(25, 588, 325, 108, "Exit"))
    {
        game_end();
    }
}

//Choosing Fighter Screen
if screen_state == SCREEN_CHOOSE_FIGHTER
{
    draw_set_colour(c_navy);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1);

    draw_set_colour(c_white);
    draw_set_font(Font1);
    // Title with shadow
    draw_set_colour(c_dkgray);
    draw_text(378, 53, "Choose Your Fighter!");
    draw_set_colour(c_white);
    draw_text(375, 50, "Choose Your Fighter!");

    // Styled rectangle with border
    draw_set_colour(c_dkgray);
    draw_rectangle(48, 398, 1237, 702, true);
    draw_set_colour(c_aqua);
    draw_rectangle(50, 400, 1235, 700, true);
    draw_set_colour(c_white);
    draw_rectangle(50, 400, 1235, 700, true);
	draw_set_font(Font2)

    // Network buttons (under title)
    var host_btn_disabled = (network_type == "host" || host_full);
    if (host_btn_disabled)
    {
        ui_locked_button(400, 100, 150, 40, "Host Game");
    }
    else
    {
        if (ui_button(400, 100, 150, 40, "Host Game"))
        {
            show_host_dropdown = !show_host_dropdown;
            show_join_dropdown = false;
        }
    }
    
    var join_btn_disabled = (network_type == "host" || host_full);
    if (join_btn_disabled)
    {
        ui_locked_button(575, 100, 150, 40, "Join Game");
    }
    else
    {
        if (ui_button(575, 100, 150, 40, "Join Game"))
        {
            show_join_dropdown = !show_join_dropdown;
            show_host_dropdown = false;
        }
    }

    // Host dropdown (shows code)
    if (show_host_dropdown)
    {
        draw_set_colour(c_dkgray);
        draw_rectangle(373, 142, 527, 190, false);
        draw_set_colour(c_navy);
        draw_rectangle(375, 144, 525, 188, false);
        draw_set_colour(c_white);
        draw_text(380, 147, "Code: " + string(host_code));
        
        if (ui_button(380, 195, 140, 30, "Randomize"))
        {
            host_code = string(floor(random(9000)) + 1000) // 4-digit code
            show_debug_message("Host code randomized: " + host_code);
        }
        // Start Host is only allowed when a 4-digit host code is present
        if (string_length(host_code) == 4 && !host_full && ui_button(530, 195, 140, 30, "Start Host"))
        {
            network_type = "host";
            server_socket = network_create_server(network_socket_tcp, PORT, 2);
            lobby_created = true;
            // Do not automatically close the host UI; keep it open for feedback/changes
            show_debug_message("Starting Host with code: " + host_code);
        }
        // Cancel Host button when hosting
        if (network_type == "host" && lobby_created)
        {
            if (ui_button(380, 230, 140, 30, "Cancel Host"))
            {
                if (server_socket != -1) {
                    network_destroy(server_socket);
                }
                server_socket = -1;
                lobby_created = false;
                network_type = "none";
                host_full = false;
                connected_clients = 0;
            }
        }
    }

    // Join dropdown (enter code)
    if (show_join_dropdown)
    {
        draw_set_colour(c_dkgray);
        draw_rectangle(533, 142, 687, 190, false);
        draw_set_colour(c_navy);
        draw_rectangle(535, 144, 685, 188, false);
        draw_set_colour(c_white);
        draw_text(540, 147, "Enter Code:");
        
        // Simple code input (for demo - you'd want a proper input field)
        draw_text(540, 165, join_code);
        
        // Connect button upgrades: enable only when a 4-digit code is entered
        if (string_length(join_code) == 4)
        {
        if (ui_button(540, 195, 140, 30, "Connect"))
        {
            network_type = "client";
            client_socket = network_create_socket(network_socket_tcp);
            network_connect(client_socket, "127.0.0.1", PORT);
                
                // Send code to host for verification
                var buffer = buffer_create(256, buffer_fixed, 1);
                buffer_write(buffer, buffer_string, "code:" + join_code);
                network_send_packet(client_socket, buffer, buffer_tell(buffer));
                buffer_delete(buffer);
                
                // Do not automatically close the join UI; keep it open for feedback/changes
            }
        }
    }

    // Fighter buttons at top-left of rectangle
    var btn_x = 82;  // 50 + 32 (center of 64-wide sprite at left edge 50)
    var btn_y = 432; // 400 + 32 (center of 64-tall sprite at top edge 400)
    var btn_spacing = 70;

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // MegaMind Duck button (64x64 sprite, origin at center)
    draw_sprite(spr_megamindduck_front, 0, btn_x, btn_y);
    if (mx >= btn_x - 32 && mx <= btn_x + 32 && my >= btn_y - 32 && my <= btn_y + 32)
    {
        if (mouse_check_button_pressed(mb_left))
        {
            chosen_animal = "megamind";
            if (network_type != "none") network_send_animal();
        }
    }

    // Bardarius button (64x64 sprite, origin at center)
    var btn2_x = btn_x + btn_spacing;
    draw_sprite(spr_bardarius_front, 0, btn2_x, btn_y);
    if (mx >= btn2_x - 32 && mx <= btn2_x + 32 && my >= btn_y - 32 && my <= btn_y + 32)
    {
        if (mouse_check_button_pressed(mb_left))
        {
            chosen_animal = "bardarius";
            if (network_type != "none") network_send_animal();
        }
    }

    // Barthemus button (now 64x64 sprite, origin at center)
    var btn3_x = btn2_x + btn_spacing;
    draw_sprite(spr_barthemus_front, 0, btn3_x, btn_y);
    if (mx >= btn3_x - 32 && mx <= btn3_x + 32 && my >= btn_y - 32 && my <= btn_y + 32)
    {
        if (mouse_check_button_pressed(mb_left))
        {
            chosen_animal = "barthemus";
            if (network_type != "none") network_send_animal();
        }
    }

// Really big preview of YOUR chosen animal (above the rectangle, left side)
    // Align left edge at x=50 (same as rectangle), center at 50+192=242
    if chosen_animal == "megamind"
    {
        draw_sprite_ext(spr_megamindduck_front, 0, 242, 202, 6, 6, 0, c_white, 1);
    }
    else if chosen_animal == "bardarius"
    {
        draw_sprite_ext(spr_bardarius_front, 0, 242, 202, 6, 6, 0, c_white, 1);
    }
    else if chosen_animal == "barthemus"
    {
        // Now 64x64, so same as others: 6x scale, y=202
        draw_sprite_ext(spr_barthemus_front, 0, 242, 202, 6, 6, 0, c_white, 1);
    }

    // Really big preview of OPPONENT'S chosen animal (above the rectangle, right side)
    // Align right edge at x=1235 (same as rectangle), center at 1235-192=1043
    if opponent_animal == "megamind"
    {
        draw_sprite_ext(spr_megamindduck_front, 0, 1043, 202, 6, 6, 0, c_white, 1);
    }
    else if opponent_animal == "bardarius"
    {
        draw_sprite_ext(spr_bardarius_front, 0, 1043, 202, 6, 6, 0, c_white, 1);
    }
    else if opponent_animal == "barthemus"
    {
        draw_sprite_ext(spr_barthemus_front, 0, 1043, 202, 6, 6, 0, c_white, 1);
    }

    // Network status and Ready button
    if (network_type != "none")
    {
        draw_set_colour(c_white);
        draw_text(50, 700, "Connected as: " + network_type);
        if (chosen_animal != "")
        {
            draw_text(250, 700, "Selected: " + chosen_animal);
        }
        if (opponent_animal != "")
        {
            draw_text(500, 700, "Opponent: " + opponent_animal);
        }
        
        // Ready button
        if (chosen_animal != "" && !my_ready)
        {
            if (ui_button(750, 650, 200, 40, "Ready"))
            {
                network_send_ready();
                my_ready = true;
            }
        }
        if (my_ready)
        {
            draw_text(750, 700, "You are ready!");
        }
        if (opponent_ready)
        {
            draw_text(900, 700, "Opponent ready!");
        }
    }
	
	if (keyboard_check_pressed(ord("P"))
	){
		screen_state = SCREEN_BATTLE
	 }
}

//Settings Menu
if screen_state == SCREEN_OPTIONS
{
    
}

//Achievements Menu
if screen_state == SCREEN_ACHIEVEMENTS
{
    draw_set_colour(c_grey);
    draw_rectangle(0, 0, 1280, 720, false);

    draw_set_alpha(0.30);
    draw_set_colour(c_navy);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1);

    draw_set_colour(c_white);
    draw_set_font(Font1);
    // Title with shadow
    draw_set_colour(c_dkgray);
    draw_text(447, 118, "Animal Arena!");
    draw_set_colour(c_white);
    draw_text(446, 117, "Animal Arena!");

    if (ui_locked_button(446, 317, 325, 108, "Play"))
    {
        screen_state = SCREEN_CHOOSE_FIGHTER;
    }

    if (ui_locked_button(446, 450, 325, 108, "Settings"))
    {
        screen_state = SCREEN_OPTIONS;
    }

    if (ui_locked_button(446, 588, 325, 108, "Achievements"))
    {
        screen_state = SCREEN_ACHIEVEMENTS;
    }

    draw_set_alpha(1);

    if (ui_button(25, 588, 325, 108, "Exit"))
    {
        game_end();
    }

    // Styled rectangle with border
    draw_set_colour(c_dkgray);
    draw_rectangle(444, 115, 783, 560, false);
    draw_set_colour(c_aqua);
    draw_rectangle(446, 117, 781, 558, false);
    draw_set_colour(c_blue);
    draw_rectangle(446, 117, 781, 558, true);
    
    // Back button area
    draw_set_colour(c_dkgray);
    draw_rectangle(23, 23, 352, 135, false);
    draw_set_colour(c_red);
    draw_rectangle(25, 25, 350, 133, false);

    draw_set_alpha(0.5);
    
    if (ui_button(25, 25, 325, 108, "Back"))
    {
        screen_state = SCREEN_START;
    }
    
    draw_set_alpha(1);
}
