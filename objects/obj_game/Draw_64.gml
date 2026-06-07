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

    draw_set_colour(c_dkgray);
    draw_set_font(Font1);
    draw_text(378, 53, "Choose Your Fighter!");
    draw_set_colour(c_white);
    draw_text(375, 50, "Choose Your Fighter!");

    // Fighter selection panel
    draw_set_colour(c_dkgray);
    draw_rectangle(48, 270, 1237, 700, true);
    draw_set_colour(c_aqua);
    draw_rectangle(50, 272, 1235, 698, true);
    draw_set_colour(c_white);
    draw_rectangle(50, 272, 1235, 698, true);

    // ---- Network Buttons ----
    // Host Game
    if (network_type == "host" && lobby_created)
    {
        ui_small_locked_button(400, 100, 150, 40, "Host Game");
        if (ui_small_button(400, 165, 150, 25, "Cancel"))
        {
            if (server_socket != -1) network_destroy(server_socket);
            server_socket = -1;
            lobby_created = false;
            network_type = "none";
            host_full = false;
            connected_clients = 0;
        }
    }
    else
    {
        var host_btn_disabled = (network_type == "host" || host_full);
        if (host_btn_disabled)
        {
            ui_small_locked_button(400, 100, 150, 40, "Host Game");
        }
        else
        {
            if (ui_small_button(400, 100, 150, 40, "Host Game"))
            {
                show_host_dropdown = !show_host_dropdown;
                show_join_dropdown = false;
            }
        }
    }

    // Host dropdown
    if (show_host_dropdown && !(network_type == "host" && lobby_created))
    {
        draw_set_colour(c_dkgray);
        draw_rectangle(373, 142, 527, 220, false);
        draw_set_colour(c_navy);
        draw_rectangle(375, 144, 525, 218, false);
        draw_set_colour(c_white);
        draw_text(380, 147, "Code: " + string(host_code));

        if (ui_small_button(380, 195, 140, 30, "Randomize"))
        {
            host_code = string(floor(random(9000)) + 1000);
            host_error = "";
        }

        // Check if another device is already hosting this code
        var _code_taken = false;
        for (var _i = 0; _i < ds_list_size(discovered_hosts); _i++)
        {
            if (discovered_hosts[| _i][? "code"] == host_code)
            {
                _code_taken = true;
                break;
            }
        }

        if (_code_taken)
        {
            host_error = "Code already in use on network";
            draw_set_colour(c_red);
            draw_text(380, 228, host_error);
        }

        if (string_length(host_code) == 4 && !host_full && !_code_taken && ui_small_button(530, 195, 140, 30, "Start Host"))
        {
            network_type = "host";
            server_socket = network_create_server(network_socket_tcp, PORT, 2);
            lobby_created = true;
            show_host_dropdown = false;
        }
    }

    // Join Game
    var join_btn_disabled = (network_type == "host" || host_full);
    if (join_btn_disabled)
    {
        ui_small_locked_button(575, 100, 150, 40, "Join Game");
    }
    else
    {
        if (ui_small_button(575, 100, 150, 40, "Join Game"))
        {
            show_join_dropdown = !show_join_dropdown;
            show_host_dropdown = false;
        }
    }

    // Join dropdown
    if (show_join_dropdown)
    {
        draw_set_colour(c_dkgray);
        draw_rectangle(533, 142, 687, 190, false);
        draw_set_colour(c_navy);
        draw_rectangle(535, 144, 685, 188, false);
        draw_set_colour(c_white);
        draw_text(540, 147, "Enter Code:");
        draw_text(540, 165, join_code);

        if (string_length(join_code) == 4)
        {
            // Find a host broadcasting this code
            var _target_ip = "";
            for (var _i = 0; _i < ds_list_size(discovered_hosts); _i++)
            {
                var _entry = discovered_hosts[| _i];
                if (_entry[? "code"] == join_code)
                {
                    _target_ip = _entry[? "ip"];
                    break;
                }
            }

            if (_target_ip != "")
            {
                if (ui_small_button(540, 195, 140, 30, "Connect"))
                {
                    network_type = "client";
                    client_socket = network_create_socket(network_socket_tcp);
                    network_connect(client_socket, _target_ip, PORT);

                    var buffer = buffer_create(256, buffer_fixed, 1);
                    buffer_write(buffer, buffer_string, "code:" + join_code);
                    network_send_packet(client_socket, buffer, buffer_tell(buffer));
                    buffer_delete(buffer);
                    show_join_dropdown = false;
                }
            }
            else
            {
                draw_set_colour(c_red);
                draw_text(540, 200, "No host found with that code");
            }
        }
    }

    // ---- Preview Area ----
    // Labels
    draw_set_font(Font2);
    draw_set_colour(c_silver);
    if (opponent_animal != "") draw_text(1043, 115, "Opponent");

    // Big preview of YOUR chosen animal (left side)
    var _ps = 3;
    if chosen_animal == "megamind"
    {
        draw_sprite_ext(spr_megamindduck_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "bardarius"
    {
        draw_sprite_ext(spr_bardarius_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "barthemus"
    {
        draw_sprite_ext(spr_barthemus_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "thorn"
    {
        draw_sprite_ext(spr_thorn_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "gravity"
    {
        draw_sprite_ext(spr_gravity_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "breadduck"
    {
        draw_sprite_ext(spr_bread_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "frog"
    {
        draw_sprite_ext(spr_pond_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "dartfrog"
    {
        draw_sprite_ext(spr_dartfrog_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "bullfrog"
    {
        draw_sprite_ext(spr_bullfrog_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "treefrog"
    {
        draw_sprite_ext(spr_treefrog_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "glassfrog"
    {
        draw_sprite_ext(spr_glassfrog_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }
    else if chosen_animal == "sprig"
    {
        draw_sprite_ext(spr_sprig_front, 0, 190, 155, _ps, _ps, 0, c_white, 1);
    }

    // Big preview of OPPONENT'S chosen animal (right side)
    if opponent_animal == "megamind"
    {
        draw_sprite_ext(spr_megamindduck_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "bardarius"
    {
        draw_sprite_ext(spr_bardarius_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "frog"
    {
        draw_sprite_ext(spr_pond_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "dartfrog"
    {
        draw_sprite_ext(spr_dartfrog_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "bullfrog"
    {
        draw_sprite_ext(spr_bullfrog_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "treefrog"
    {
        draw_sprite_ext(spr_treefrog_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "glassfrog"
    {
        draw_sprite_ext(spr_glassfrog_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "sprig"
    {
        draw_sprite_ext(spr_sprig_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "barthemus"
    {
        draw_sprite_ext(spr_barthemus_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "thorn"
    {
        draw_sprite_ext(spr_thorn_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "gravity"
    {
        draw_sprite_ext(spr_gravity_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }
    else if opponent_animal == "breadduck"
    {
        draw_sprite_ext(spr_bread_front, 0, 1043, 155, _ps, _ps, 0, c_white, 1);
    }

    // ---- Practice / Ready Button (centered above fighter panel) ----
    var action_x = 540;
    var action_y = 215;

    if (network_type == "none")
    {
        // Practice button (no lobby)
        if (chosen_animal != "" && chosen_animal != "none")
        {
            if (ui_small_button(action_x, action_y, 200, 40, "Practice"))
            {
                screen_state = SCREEN_BATTLE
            }
        }
        else
        {
            ui_small_locked_button(action_x, action_y, 200, 40, "Practice");
        }
    }
    else
    {
        // Host code display above the ready button
        if (network_type == "host" && lobby_created)
        {
            draw_set_font(Font2);
            draw_set_halign(fa_center);
            draw_set_colour(c_aqua);
            draw_text(action_x + 100, action_y - 30, "Your Code: " + string(host_code));
            draw_set_halign(fa_left);
        }

        // Panel behind ready button
        draw_set_colour(c_black);
        draw_set_alpha(0.3);
        draw_rectangle(action_x - 10, action_y - 10, action_x + 210, action_y + 50, false);
        draw_set_alpha(1);

        if (my_ready)
        {
            if (ui_small_button(action_x, action_y, 200, 40, "Unready"))
            {
                my_ready = false;
                opponent_ready = false;
                var buffer = buffer_create(256, buffer_fixed, 1);
                buffer_write(buffer, buffer_string, "unready");
                if (network_type == "host" && client_socket != -1)
                    network_send_packet(client_socket, buffer, buffer_tell(buffer));
                else if (network_type == "client" && client_socket != -1)
                    network_send_packet(client_socket, buffer, buffer_tell(buffer));
                buffer_delete(buffer);
            }
        }
        else if (chosen_animal != "" && chosen_animal != "none")
        {
            if (ui_small_button(action_x, action_y, 200, 40, "Ready"))
            {
                network_send_ready();
                my_ready = true;
            }
        }
        else
        {
            ui_small_locked_button(action_x, action_y, 200, 40, "Ready");
        }

        if (opponent_ready)
        {
            draw_set_colour(c_lime);
            draw_text(action_x + 100, action_y + 45, "Opponent ready!");
        }
    }

    // ---- Fighter Buttons ----
    var btn_x1 = 80;
    var btn_x2 = 180;
    var btn_y = 304;
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Selected highlight
    draw_set_colour(c_yellow);

    // Column 1 (duck track): Bardarius, Barthemus, Thorn, Gravity, MegaMind, Bread Duck (hidden)
    // Column 2 (frog track): Pond Frog, Dart Frog, Bullfrog, Tree Frog, Glass Frog, Sprig (hidden)
    for (var _si = 0; _si < 12; _si++)
    {
        var _col = _si < 6 ? 0 : 1;
        var _row = _si % 6;
        var _bx = _col == 0 ? btn_x1 : btn_x2;
        var _col_vspacing = (_col == 0) ? ((!achiev_claimed[4]) ? 90 : 72) : ((!achiev_claimed[10]) ? 90 : 72);
        var _by = btn_y + _row * _col_vspacing;

        var _animal = "";
        var _sprite = -1;
        var _locked = false;
        var _hidden = false;

        // Assign slot data based on index
        if (_si == 0) { _animal = "bardarius"; _sprite = spr_bardarius_front; }
        else if (_si == 1) { _animal = "barthemus"; _sprite = spr_barthemus_front; _locked = !achiev_claimed[0]; }
        else if (_si == 2) { _animal = "thorn"; _sprite = spr_thorn_front; _locked = !achiev_claimed[1]; }
        else if (_si == 3) { _animal = "gravity"; _sprite = spr_gravity_front; _locked = !achiev_claimed[2]; }
        else if (_si == 4) { _animal = "megamind"; _sprite = spr_megamindduck_front; _locked = !(achiev_claimed[0] && achiev_claimed[1] && achiev_claimed[2] && achiev_claimed[3]); }
        else if (_si == 5) { _animal = "breadduck"; _sprite = spr_bread_front; _hidden = !achiev_claimed[4]; }
        else if (_si == 6) { _animal = "frog"; _sprite = spr_pond_front; }
        else if (_si == 7) { _animal = "dartfrog"; _sprite = spr_dartfrog_front; _locked = !achiev_claimed[5]; }
        else if (_si == 8) { _animal = "bullfrog"; _sprite = spr_bullfrog_front; _locked = !achiev_claimed[6]; }
        else if (_si == 9) { _animal = "treefrog"; _sprite = spr_treefrog_front; _locked = !achiev_claimed[7]; }
        else if (_si == 10) { _animal = "glassfrog"; _sprite = spr_glassfrog_front; _locked = !achiev_claimed[8]; }
        else if (_si == 11) { _animal = "sprig"; _sprite = spr_sprig_front; _hidden = !achiev_claimed[10]; }

        if (_hidden) continue;

        // Highlight selected
        if (chosen_animal == _animal)
            draw_rectangle(_bx - 34, _by - 34, _bx + 34, _by + 34, true);

        // Draw sprite (locked = gray)
        if (_locked)
            draw_sprite_ext(_sprite, 0, _bx, _by, 1, 1, 0, make_color_rgb(60, 60, 60), 1);
        else
            draw_sprite(_sprite, 0, _bx, _by);

        // Click detection
        if (!_locked && mx >= _bx - 32 && mx <= _bx + 32 && my >= _by - 32 && my <= _by + 32)
        {
            if (mouse_check_button_pressed(mb_left))
            {
                chosen_animal = _animal;
                if (network_type != "none") network_send_animal();
            }
        }
    }


    if (keyboard_check_pressed(vk_escape))
    {
        screen_state = SCREEN_START
    }
}

//Battle Screen
if screen_state == SCREEN_BATTLE
{
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    draw_set_colour(c_green);
    draw_rectangle(0, 0, 1280, 720, false);

    if (ability_name != "")
    {
        draw_set_font(Font2);
        draw_set_colour(c_white);
        draw_text(20, 20, "Ability: " + ability_name + " (" + ability_type + ")");

        if (ability_type == "active")
        {
            if (ability_active)
            {
                draw_set_colour(c_lime);
                draw_text(20, 45, "Active: " + string(ability_timer / 60) + "s");
                if (mind_control_active)
                {
                    draw_set_colour(c_aqua);
                    draw_text(20, 65, "Controlling opponent!");
                }
            }
            else if (ability_cooldown_timer > 0)
            {
                draw_set_colour(c_red);
                draw_text(20, 45, "Cooldown: " + string(ability_cooldown_timer / 60) + "s");
            }
            else
            {
                draw_set_colour(c_silver);
                draw_text(20, 45, "Ability Ready! Press RMB to use.");
            }
        }
        else
        {
            draw_set_colour(c_silver);
            draw_text(20, 45, ability_desc);
        }
    }

    if (projectile_active)
    {
        var _dir = point_direction(0, 0, projectile_hspeed, projectile_vspeed);
        draw_sprite_ext(spr_barthemus_projectile, 0, projectile_x, projectile_y, 1, 1, _dir, c_white, 1);
    }

    if (poison_dart_active)
    {
        var _dir = point_direction(0, 0, poison_dart_hspeed, poison_dart_vspeed);
        draw_sprite_ext(spr_thorn_projectile, 0, poison_dart_x, poison_dart_y, 1, 1, _dir, c_white, 1);
    }

    if (breadcrumb_active)
    {
        draw_sprite(spr_breadcrumb, 0, breadcrumb_x, breadcrumb_y);
    }

    if (frog_projectile_active)
    {
        var _fglob = spr_poison_glob_right;
        if (frog_projectile_vspeed < 0) _fglob = spr_poison_glob_up;
        else if (frog_projectile_vspeed > 0) _fglob = spr_poison_glob_down;
        else if (frog_projectile_hspeed < 0) _fglob = spr_poison_glob_left;
        draw_sprite(_fglob, 0, frog_projectile_x, frog_projectile_y);
    }

    if (sprig_slingshot_active)
    {
        draw_sprite(spr_pebble, 0, sprig_slingshot_x, sprig_slingshot_y);
    }

    if (instance_exists(obj_player))
    {
        var _hp_target = instance_find(obj_player, 0);
        if (network_type == "none" && !practice_all_mode && practice_controlled_duck != noone && instance_exists(practice_controlled_duck))
            _hp_target = practice_controlled_duck;
        draw_set_font(Font2);
        draw_set_colour(c_white);
        draw_text(20, 670, "HP");
        draw_set_colour(c_black);
        draw_rectangle(20, 690, 270, 720, false);
        draw_set_colour(c_red);
        draw_rectangle(22, 692, 22 + (246 * max(0, _hp_target.hp) / 100), 718, false);
    }

    // Practice mode: spawn menu (top middle)
    if (network_type == "none")
    {
        draw_set_font(Font2);
        var _ax = 640, _ay = 5;
        draw_set_halign(fa_center);
        draw_set_colour(c_white);
        draw_text(_ax, _ay, practice_menu_open ? "v" : "^");
        draw_set_halign(fa_left);
        if (mx >= _ax - 20 && mx <= _ax + 20 && my >= _ay - 5 && my <= _ay + 25 && mouse_check_button_pressed(mb_left))
        {
            practice_menu_open = !practice_menu_open;
            if (!practice_menu_open) { practice_cursor_type = ""; practice_cursor_sprite = -1; }
        }

        if (practice_menu_open)
        {
            var _mx = 540, _my = 30;
            draw_set_colour(c_black);
            draw_rectangle(_mx, _my, _mx + 200, _my + 330, false);
            draw_set_colour(c_dkgray);
            draw_rectangle(_mx + 2, _my + 2, _mx + 198, _my + 328, false);
            draw_set_colour(c_white);
            draw_text(_mx + 10, _my + 5, "Spawn Duck:");

            // Spawn buttons - click to pick up character on cursor
            var _sy = 25;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "bardarius")) { practice_cursor_type = "bardarius"; practice_cursor_sprite = spr_bardarius_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "frog")) { practice_cursor_type = "frog"; practice_cursor_sprite = spr_pond_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "dartfrog")) { practice_cursor_type = "dartfrog"; practice_cursor_sprite = spr_dartfrog_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "bullfrog")) { practice_cursor_type = "bullfrog"; practice_cursor_sprite = spr_bullfrog_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "treefrog")) { practice_cursor_type = "treefrog"; practice_cursor_sprite = spr_treefrog_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "glassfrog")) { practice_cursor_type = "glassfrog"; practice_cursor_sprite = spr_glassfrog_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "barthemus")) { practice_cursor_type = "barthemus"; practice_cursor_sprite = spr_barthemus_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "thorn")) { practice_cursor_type = "thorn"; practice_cursor_sprite = spr_thorn_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "gravity")) { practice_cursor_type = "gravity"; practice_cursor_sprite = spr_gravity_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "megamind")) { practice_cursor_type = "megamind"; practice_cursor_sprite = spr_megamindduck_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "breadduck")) { practice_cursor_type = "breadduck"; practice_cursor_sprite = spr_bread_front; practice_cursor_count = 3; } _sy += 24;
            if (ui_small_button(_mx + 10, _my + _sy, 180, 20, "sprig")) { practice_cursor_type = "sprig"; practice_cursor_sprite = spr_sprig_front; practice_cursor_count = 3; }

            // ALL/ONE mode toggle
            draw_set_colour(c_white);
            draw_text(_mx + 10, _my + _sy + 10, "Mode:");
            if (ui_small_button(_mx + 10, _my + _sy + 30, 180, 20, practice_all_mode ? "ALL (shared WASD)" : "ONE (controlled)"))
            {
                practice_all_mode = !practice_all_mode;
            }
        }

        // Click on map to spawn the cursor duck
        if (practice_cursor_type != "" && practice_menu_open && mouse_check_button_pressed(mb_left))
        {
            if (mx < 540 || mx > 740 || my < 30 || my > 360)
            {
                var _n = instance_create_depth(mx, my, -10, obj_player);
                _n.animal_type = practice_cursor_type;
                _n.sprite_index = practice_cursor_sprite;
                if (practice_cursor_type == "bardarius") _n.swing_damage = 10;
                if (practice_cursor_type == "barthemus") _n.slow_speed = 1.2;
                practice_cursor_count--;
                if (practice_cursor_count <= 0) { practice_cursor_type = ""; practice_cursor_sprite = -1; }
            }
        }

        // Draw cursor sprite
        if (practice_cursor_type != "")
        {
            draw_sprite_ext(practice_cursor_sprite, 0, mx, my, 0.5, 0.5, 0, c_white, 0.7);
            draw_set_halign(fa_center);
            draw_set_colour(c_yellow);
            draw_text(mx, my + 20, string(practice_cursor_count));
            draw_set_halign(fa_left);
        }

        // Context menu on middle-clicked duck
        if (practice_context_duck != noone && instance_exists(practice_context_duck))
        {
            var _d = practice_context_duck;
            var _cx = _d.x, _cy = _d.y;
            var _r = 18;
            var _gap = 30;

            draw_set_halign(fa_center);
            draw_set_font(Font2);

            // X (center) - close
            draw_set_colour(c_red);
            draw_circle(_cx, _cy, _r, false);
            draw_set_colour(c_white);
            draw_text(_cx, _cy, "X");

            // Wander (above)
            draw_set_colour(c_olive);
            draw_circle(_cx, _cy - _gap, _r, false);
            draw_set_colour(c_white);
            draw_text(_cx, _cy - _gap, "W");

            // Control (left) - only in ONE mode
            if (!practice_all_mode)
            {
                draw_set_colour(c_blue);
                draw_circle(_cx - _gap, _cy, _r, false);
                draw_set_colour(c_white);
                draw_text(_cx - _gap, _cy, "C");
            }

            // Copy (below)
            draw_set_colour(c_purple);
            draw_circle(_cx, _cy + _gap, _r, false);
            draw_set_colour(c_white);
            draw_text(_cx, _cy + _gap, "CP");

            // Follow (right)
            draw_set_colour(c_green);
            draw_circle(_cx + _gap, _cy, _r, false);
            draw_set_colour(c_white);
            draw_text(_cx + _gap, _cy, "F");

            draw_set_halign(fa_left);
        }

        // Health bars above practice ducks (skip controlled duck in ONE mode)
        var _pc = instance_number(obj_player);
        for (var _pi = 0; _pi < _pc; _pi++)
        {
            var _pl = instance_find(obj_player, _pi);
            if (_pl != noone)
            {
                if (!practice_all_mode && _pl.id == practice_controlled_duck) continue;
                var _bw = 30, _bh = 4;
                var _bx = _pl.x - _bw / 2, _by = _pl.y - 45;
                draw_set_colour(c_black);
                draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
                draw_set_colour(c_red);
                draw_rectangle(_bx + 1, _by + 1, _bx + 1 + (_bw - 2) * max(0, _pl.hp) / 100, _by + _bh - 1, false);
            }
        }
    }

    // Pause overlay
    if (paused)
    {
        draw_set_alpha(0.5);
        draw_set_colour(c_black);
        draw_rectangle(0, 0, 1280, 720, false);
        draw_set_alpha(1);

        draw_set_halign(fa_center);
        draw_set_font(Font1);
        draw_set_colour(c_white);
        draw_text(640, 260, "Paused!");

        if (ui_button(540, 350, 200, 50, "Resume"))
        {
            paused = false;
        }

        if (ui_button(540, 420, 200, 50, "Exit"))
        {
            paused = false;
            screen_state = SCREEN_START;
        }

        draw_set_halign(fa_left);
    }

    // Battle result
    if (battle_over)
    {
        // Falling text (phases: falling, hold)
        if (battle_phase == "falling" || battle_phase == "hold")
        {
            if (battle_phase == "falling") battle_text_y = min(battle_text_y + 3, 360);
            draw_set_halign(fa_center);
            draw_set_font(Font1);
            if (battle_result == "lose")
            {
                draw_set_colour(c_black);
                draw_text(642, battle_text_y + 2, "You Died!");
                draw_set_colour(c_red);
                draw_text(640, battle_text_y, "You Died!");
            }
            else if (battle_result == "win")
            {
                draw_set_colour(c_black);
                draw_text(642, battle_text_y + 2, "You Won!");
                draw_set_colour(c_yellow);
                draw_text(640, battle_text_y, "You Won!");
            }
            draw_set_halign(fa_left);
        }

        // Fade overlay (phases: fade, results)
        if (battle_phase == "fade" || battle_phase == "results")
        {
            draw_set_colour(c_black);
            draw_set_alpha(battle_fade_alpha);
            draw_rectangle(0, 0, 1280, 720, false);
            draw_set_alpha(1);
        }

        // Results screen
        if (battle_phase == "results")
        {
            draw_set_halign(fa_center);
            draw_set_font(Font1);
            draw_set_colour(c_white);
            draw_text(640, 180, "Match completed");

            if (ui_button(540, 300, 200, 50, "Rematch"))
            {
                with (obj_player) instance_destroy();
                battle_over = false;
                battle_phase = "falling";
                battle_text_y = -300;
                battle_fade_alpha = 0;
                battle_hold_timer = 0;
                ability_name = "";
                ability_active = false;
                ability_timer = 0;
                ability_cooldown_timer = 0;
                projectile_active = false;
                poison_dart_active = false;
                breadcrumb_active = false;
                mind_control_active = false;
                rematch_ready = false;
                frog_projectile_active = false;
                sprig_slingshot_active = false;
            }

            if (ui_button(540, 370, 200, 50, "Return"))
            {
                with (obj_player) instance_destroy();
                battle_over = false;
                battle_phase = "falling";
                battle_text_y = -300;
                battle_fade_alpha = 0;
                battle_hold_timer = 0;
                ability_name = "";
                ability_active = false;
                ability_timer = 0;
                ability_cooldown_timer = 0;
                projectile_active = false;
                poison_dart_active = false;
                breadcrumb_active = false;
                mind_control_active = false;
                rematch_ready = false;
                frog_projectile_active = false;
                sprig_slingshot_active = false;
                screen_state = SCREEN_CHOOSE_FIGHTER;
            }

            draw_set_halign(fa_left);
        }
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

    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Title
    draw_set_font(Font1);
    draw_set_colour(c_dkgray);
    draw_text(37, 28, "Achievements");
    draw_set_colour(c_white);
    draw_text(35, 25, "Achievements");

    // Search bar
    draw_set_colour(c_black);
    draw_rectangle(35, 75, 400, 105, false);
    draw_set_colour(c_aqua);
    draw_rectangle(37, 77, 398, 103, true);

    var search_active = (achiev_focused == true);
    draw_set_colour(search_active ? c_aqua : c_silver);
    draw_set_font(Font2);
    draw_text(40, 81, "Search: " + achiev_search + (search_active ? "_" : ""));

    if (mx >= 35 && mx <= 400 && my >= 75 && my <= 105 && mouse_check_button_pressed(mb_left))
    {
        achiev_focused = true;
    }
    else if (mouse_check_button_pressed(mb_left))
    {
        achiev_focused = false;
    }

    // Back button
    draw_set_colour(c_dkgray);
    draw_rectangle(35, 115, 160, 150, false);
    draw_set_colour(c_red);
    draw_rectangle(37, 117, 158, 148, true);
    if (ui_button(35, 115, 125, 35, "Back"))
    {
        screen_state = SCREEN_START;
    }

    // Debug: toggle unlock for achievements
    if (ui_small_button(35, 230, 125, 20, "Debug: Toggle"))
    {
        for (var _i = 0; _i < achiev_count; _i++)
        {
            achiev_unlocked[_i] = !achiev_unlocked[_i];
        }
    }

    // Scroll buttons
    if (ui_small_button(35, 160, 125, 25, "Up"))
    {
        achiev_id = max(0, achiev_id - 1);
    }
    if (ui_small_button(35, 190, 125, 25, "Down"))
    {
        achiev_id = min(achiev_count - 1, achiev_id + 1);
    }

    // Achievement list area
    draw_set_colour(c_dkgray);
    draw_rectangle(170, 75, 1250, 700, false);
    draw_set_colour(c_navy);
    draw_rectangle(172, 77, 1248, 698, false);

    var yy = 90;
    var shown = 0;
    for (var i = 0; i < achiev_count; i++)
    {
        // Hidden achievements and unused slots
        if (i == 9) continue;
        if ((i == 4 || i == 10) && !achiev_unlocked[i]) continue;

        var aname = achiev_name[i];
        var adesc = achiev_desc[i];
        var aclaimed = achiev_claimed[i];
        var aunlocked = achiev_unlocked[i];

        // Search filter: skip if search active and neither name nor desc match
        if (achiev_search != "" && string_pos(string_lower(achiev_search), string_lower(aname)) == 0
            && string_pos(string_lower(achiev_search), string_lower(adesc)) == 0) continue;

        if (shown < achiev_id) { shown++; continue; }
        if (yy > 670) break;

        // Achievement card
        draw_set_colour(aclaimed ? make_color_rgb(30, 40, 30) : make_color_rgb(40, 40, 50));
        draw_rectangle(180, yy, 1240, yy + 70, false);

        draw_set_font(Font2);
        draw_set_colour(aclaimed || aunlocked ? c_lime : c_white);
        draw_text(190, yy + 5, aname);

        if (aclaimed || aunlocked)
        {
            draw_set_colour(aclaimed ? c_gray : c_silver);
            draw_text(190, yy + 28, adesc);
        }

        // Status / Claim button
        if (aclaimed)
        {
            draw_set_colour(c_lime);
            draw_text(1170, yy + 20, "Claimed!");
        }
        else if (aunlocked)
        {
            if (ui_small_button(1150, yy + 17, 80, 30, "Claim"))
            {
                achiev_claimed[i] = true;
            }
        }
        else
        {
            draw_set_colour(c_red);
            draw_text(1140, yy + 25, "LOCKED");
        }

        yy += 75;
        shown++;
    }

    // Scrolling indicator
    draw_set_font(Font2);
    draw_set_colour(c_silver);
    draw_text(35, 220, "Page: " + string(achiev_id + 1) + "/" + string(achiev_count));
}

// Achievement toast (draws on top of everything)
if (achiev_toast_timer > 0)
{
    draw_set_font(Font2);
    draw_set_halign(fa_right);
    draw_set_colour(c_black);
    draw_text(1278, 15, achiev_toast_text);
    draw_set_colour(c_yellow);
    draw_text(1280, 13, achiev_toast_text);
    draw_set_halign(fa_left);
}
