/// @description Networking step and input handling
if (network_type == "host" || network_type == "client")
{
    // Send chosen animal when it changes
    if (chosen_animal != "" && !game_started)
    {
        var buffer = buffer_create(256, buffer_fixed, 1);
        buffer_write(buffer, buffer_string, "animal:" + chosen_animal);
        if (network_type == "host" && server_socket != -1)
        {
            network_send_packet(server_socket, buffer, buffer_tell(buffer));
        }
        else if (network_type == "client" && client_socket != -1)
        {
            network_send_packet(client_socket, buffer, buffer_tell(buffer));
        }
        buffer_delete(buffer);
    }
}

// LAN discovery - host broadcasts UDP beacon
if (network_type == "host" && lobby_created)
{
    if (udp_socket == -1)
        udp_socket = network_create_socket(network_socket_udp);

    broadcast_timer--;
    if (broadcast_timer <= 0)
    {
        broadcast_timer = 60;
        var _buff = buffer_create(64, buffer_fixed, 1);
        buffer_write(_buff, buffer_string, "HOST:" + host_code);
        network_send_broadcast(udp_socket, BROADCAST_PORT, _buff, buffer_tell(_buff));
        buffer_delete(_buff);
    }
	var n_id = ds_map_find_value(async_load, "id");					 // get the ID of the socket receiving the data
	if (n_id == server_socket)										 // check ID to make sure it is that of the server socket
	{
		var t = ds_map_find_value(async_load, "type");				 // get the type of network event
		switch(t)
		    {
		    case network_type_connect:
		        var sock = ds_map_find_value(async_load, "socket");  // get the socket ID of the connection
		        ds_list_add(socketlist, sock);						 // then write it to a DS list for future reference
		        break;
		    case network_type_disconnect:
		        sock = ds_map_find_value(async_load, "socket");
		        ds_list_delete(socketlist, sock);
		        break;
		    }
	}
	
	if (n_id == client_socket)
	{
		var t = ds_map_find_value(async_load, "type");
		if (t == network_type_data)
		{
			// Data handling here...
		}
	}
}

// Ensure UDP socket exists when join dropdown is open (to receive broadcasts)
if (show_join_dropdown && udp_socket == -1)
    udp_socket = network_create_socket(network_socket_udp);

// Clean up stale discovered hosts (no beacon for 5 seconds = stale)
for (var _i = ds_list_size(discovered_hosts) - 1; _i >= 0; _i--)
{
    var _entry = discovered_hosts[| _i];
    _entry[? "timer"]--;
    if (_entry[? "timer"] <= 0)
    {
        ds_map_destroy(_entry);
        ds_list_delete(discovered_hosts, _i);
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
    var _old_len = string_length(host_code);
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
    if (string_length(host_code) != _old_len) host_error = "";
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
        var _new_player = instance_create_depth(500, 360, -10, obj_player);
        local_player_id = _new_player.id;
        if (network_type == "none") practice_controlled_duck = _new_player.id;
    }

    // Pause toggle
    if (network_type == "none" && keyboard_check_pressed(vk_escape))
        paused = !paused;
    if (paused) exit;

    // Battle phase transitions
    if (battle_over)
    {
        if (battle_phase == "falling" && battle_text_y >= 360)
        {
            battle_phase = "hold";
            battle_hold_timer = 180;
        }
        else if (battle_phase == "hold")
        {
            battle_hold_timer--;
            if (battle_hold_timer <= 0) battle_phase = "fade";
        }
        else if (battle_phase == "fade")
        {
            battle_fade_alpha = min(battle_fade_alpha + 0.02, 1);
            if (battle_fade_alpha >= 1) battle_phase = "results";
        }
        exit;
    }

    // Set ability data on first entry
    if (ability_name == "")
    {
        switch (chosen_animal)
        {
            case "megamind":
                ability_type = "active"; ability_name = "Mind Control"; ability_desc = "Control the opponent for 7.5s";
                ability_duration = 7.5 * 60; ability_cooldown = 10 * 60; break;
case "bardarius":
    ability_type = "passive"; ability_name = "Baseball Bat"; ability_desc = "Swing deals 10 damage. More range."; break;
            case "barthemus":
                ability_type = "active"; ability_name = "Spit"; ability_desc = "Spits a projectile";
                ability_cooldown = 6 * 60; break;
            case "thorn":
                ability_type = "active"; ability_name = "Poison Dart"; ability_desc = "Fires a poison dart that deals 5 DPS for 4s";
                ability_cooldown = 5 * 60; break;
            case "gravity":
                ability_type = "active"; ability_name = "Gravity Field"; ability_desc = "5s: fast move, fast+strong swing, global slow";
                ability_duration = 5 * 60; ability_cooldown = 10 * 60; break;
            case "breadduck":
                ability_type = "active"; ability_name = "Breadcrumb"; ability_desc = "Drop a crumb that pulls enemies toward it";
                ability_cooldown = 8 * 60; break;
            case "frog":
                ability_type = "active"; ability_name = "Croak"; ability_desc = "Open mouth to catch & reflect next projectile";
                ability_cooldown = 6 * 60; break;
            case "dartfrog":
                ability_type = "active"; ability_name = "Poison Spit"; ability_desc = "Fire a poison glob that deals 5 dmg + DoT";
                ability_cooldown = 7 * 60; break;
            case "bullfrog":
                ability_type = "active"; ability_name = "Body Slam"; ability_desc = "Leap to cursor, deal 8 AoE damage on landing";
                ability_cooldown = 8 * 60; break;
            case "treefrog":
                ability_type = "active"; ability_name = "Canopy Drop"; ability_desc = "Quick leap to cursor position";
                ability_cooldown = 5 * 60; break;
            case "glassfrog":
                ability_type = "active"; ability_name = "Refraction"; ability_desc = "Turn transparent 2s, next tongue shot deals 10 dmg";
                ability_cooldown = 10 * 60; break;
            case "sprig":
                ability_type = "active"; ability_name = "Tongue Grapple"; ability_desc = "Grab enemy and swing them around";
                ability_cooldown = 10 * 60; break;
        }
    }

    if (ability_active)
    {
        ability_timer--;
        if (ability_timer <= 0)
        {
            ability_active = false;
            if (mind_control_active) mind_control_active = false;
            ability_cooldown_timer = ability_cooldown;
            if (chosen_animal == "gravity") achiev_over_here_active = false;
        }
    }
    else if (ability_cooldown_timer > 0)
    {
        ability_cooldown_timer--;
    }

    if (mouse_check_button_pressed(2))
    {
        var _ability_source = instance_find(obj_player, 0);
        if (network_type == "none" && !practice_all_mode && practice_controlled_duck != noone && instance_exists(practice_controlled_duck))
            _ability_source = practice_controlled_duck;

        if (ability_type == "active" && ability_cooldown_timer <= 0)
        {
            if (chosen_animal == "barthemus" && !projectile_active)
            {
                var _p = _ability_source;
                if (_p != noone)
                {
                    projectile_active = true;
                    projectile_x = _p.x;
                    projectile_y = _p.y;
                    projectile_owner = _p.id;
                    projectile_loops = 0;
                    projectile_shield_timer = 20;
                    if (_p.sprite_index == spr_barthemus_right) { projectile_hspeed = 8; projectile_vspeed = 0; }
                    else if (_p.sprite_index == spr_barthemus_left) { projectile_hspeed = -8; projectile_vspeed = 0; }
                    else if (_p.sprite_index == spr_barthemus_back) { projectile_hspeed = 0; projectile_vspeed = -8; }
                    else { projectile_hspeed = 0; projectile_vspeed = 8; }
                }
                ability_cooldown_timer = ability_cooldown;
            }
            else if (chosen_animal == "breadduck" && !breadcrumb_active)
            {
                var _p = _ability_source;
                if (_p != noone)
                {
                    breadcrumb_active = true;
                    breadcrumb_x = device_mouse_x_to_gui(0);
                    breadcrumb_y = device_mouse_y_to_gui(0);
                    breadcrumb_timer = 4 * 60;
                }
                ability_cooldown_timer = ability_cooldown;
            }
            else if (chosen_animal == "thorn" && !poison_dart_active)
            {
                var _p = _ability_source;
                if (_p != noone)
                {
                    poison_dart_active = true;
                    poison_dart_x = _p.x;
                    poison_dart_y = _p.y;
                    poison_dart_owner = _p.id;
                    poison_dart_loops = 0;
                    if (_p.sprite_index == spr_thorn_right) { poison_dart_hspeed = 20; poison_dart_vspeed = 0; }
                    else if (_p.sprite_index == spr_thorn_left) { poison_dart_hspeed = -20; poison_dart_vspeed = 0; }
                    else if (_p.sprite_index == spr_thorn_back) { poison_dart_hspeed = 0; poison_dart_vspeed = -20; }
                    else { poison_dart_hspeed = 0; poison_dart_vspeed = 20; }
                }
                ability_cooldown_timer = ability_cooldown;
            }
            else if (chosen_animal == "frog" && _ability_source != noone)
            {
                with (_ability_source)
                {
                    if (croak_cooldown <= 0)
                    {
                        croak_active = true;
                        croak_timer = 25;
                        croak_cooldown = 360;
                        other.ability_cooldown_timer = other.ability_cooldown;
                    }
                }
            }
            else if (chosen_animal == "dartfrog" && !frog_projectile_active && _ability_source != noone)
            {
                with (_ability_source)
                {
                    var _p = _ability_source;
                    other.frog_projectile_active = true;
                    other.frog_projectile_x = _p.x;
                    other.frog_projectile_y = _p.y;
                    other.frog_projectile_owner = _p.id;
                    if (_p.sprite_index == spr_dartfrog_right) { other.frog_projectile_hspeed = 10; other.frog_projectile_vspeed = 0; }
                    else if (_p.sprite_index == spr_dartfrog_left) { other.frog_projectile_hspeed = -10; other.frog_projectile_vspeed = 0; }
                    else if (_p.sprite_index == spr_dartfrog_back) { other.frog_projectile_hspeed = 0; other.frog_projectile_vspeed = -10; }
                    else { other.frog_projectile_hspeed = 0; other.frog_projectile_vspeed = 10; }
                }
                ability_cooldown_timer = ability_cooldown;
            }
            else if (chosen_animal == "bullfrog" && _ability_source != noone)
            {
                with (_ability_source)
                {
                    if (bullfrog_slam_cooldown <= 0)
                    {
                        bullfrog_slam_active = true;
                        bullfrog_slam_x = device_mouse_x_to_gui(0);
                        bullfrog_slam_y = device_mouse_y_to_gui(0);
                        bullfrog_slam_timer = 15;
                        bullfrog_slam_cooldown = 480;
                        other.ability_cooldown_timer = other.ability_cooldown;
                    }
                }
            }
            else if (chosen_animal == "treefrog" && _ability_source != noone)
            {
                with (_ability_source)
                {
                    if (treefrog_drop_cooldown <= 0)
                    {
                        treefrog_drop_active = true;
                        treefrog_drop_target_x = device_mouse_x_to_gui(0);
                        treefrog_drop_target_y = device_mouse_y_to_gui(0);
                        treefrog_drop_timer = 10;
                        treefrog_drop_cooldown = 300;
                        other.ability_cooldown_timer = other.ability_cooldown;
                    }
                }
            }
            else if (chosen_animal == "glassfrog" && _ability_source != noone)
            {
                with (_ability_source)
                {
                    if (glassfrog_refract_cooldown <= 0)
                    {
                        glassfrog_refract_active = true;
                        glassfrog_refract_timer = 120;
                        glassfrog_refract_cooldown = 600;
                        glassfrog_refract_boost = true;
                        other.ability_cooldown_timer = other.ability_cooldown;
                    }
                }
            }
            else if (chosen_animal == "sprig" && _ability_source != noone)
            {
                with (_ability_source)
                {
                    if (sprig_grapple_target != noone)
                    {
                        // Release with squeeze damage
                        if (instance_exists(sprig_grapple_target))
                        {
                            var _svx = sprig_grapple_last_x - sprig_grapple_prev_x;
                            var _svy = sprig_grapple_last_y - sprig_grapple_prev_y;
                            var _sspd = point_distance(0, 0, _svx, _svy);
                            if (_sspd > 1)
                            {
                                // Fling: velocity based on swing speed
                                sprig_grapple_target.kb_x = _svx * 0.2125;
                                sprig_grapple_target.kb_y = _svy * 0.2125;
                                sprig_grapple_target.kb_timer = 105;
                                other.sprig_fling_victim = sprig_grapple_target.id;
                                other.sprig_fling_start_x = sprig_grapple_target.x;
                                other.sprig_fling_start_y = sprig_grapple_target.y;
                            }
                            sprig_grapple_target.hp -= 8;
                        }
                        sprig_grapple_target = noone;
                        sprig_grapple_timer = 0;
                        sprig_grapple_cooldown = 300;
                        other.ability_cooldown_timer = other.ability_cooldown;
                    }
                    else if (sprig_grapple_cooldown <= 0)
                    {
                        // Can't grab if already grabbed by another Sprig
                        var _self_grabbed = false;
                        var _grabc = instance_number(obj_player);
                        for (var _grabi = 0; _grabi < _grabc; _grabi++)
                        {
                            var _grabp = instance_find(obj_player, _grabi);
                            if (_grabp != noone && _grabp.sprig_grapple_target == id) { _self_grabbed = true; break; }
                        }
                        if (!_self_grabbed)
                        {
                        // Find nearest enemy in range
                        var _nearest = noone;
                        var _nearest_dist = 625;
                        var _sc = instance_number(obj_player);
                        for (var _si = 0; _si < _sc; _si++)
                        {
                            var _so = instance_find(obj_player, _si);
                            if (_so != id)
                            {
                                var _sd = point_distance(x, y, _so.x, _so.y);
                                if (_sd < _nearest_dist)
                                {
                                    _nearest_dist = _sd;
                                    _nearest = _so;
                                }
                            }
                        }
                        if (_nearest != noone)
                        {
                            sprig_grapple_target = _nearest;
                            sprig_grapple_timer = 360;
                            sprig_grapple_cooldown = 600;
                            sprig_grapple_last_x = _nearest.x;
                            sprig_grapple_last_y = _nearest.y;
                            sprig_grapple_prev_x = _nearest.x;
                            sprig_grapple_prev_y = _nearest.y;
                            _nearest.hp -= 5;
                        }
                    }
                    }
                }
            }
            else if (chosen_animal != "barthemus" && chosen_animal != "thorn" && chosen_animal != "breadduck" && chosen_animal != "frog" && chosen_animal != "dartfrog" && chosen_animal != "bullfrog" && chosen_animal != "treefrog" && chosen_animal != "glassfrog" && chosen_animal != "sprig" && !ability_active)
            {
                ability_active = true;
                ability_timer = ability_duration;
                if (chosen_animal == "megamind") mind_control_active = true;
                if (chosen_animal == "gravity")
                {
                    achiev_over_here_active = true;
                    achiev_over_here_swings = 0;
                    achiev_over_here_broken = false;
                }
            }
        }
    }

    // Projectile movement
    if (projectile_active)
    {
        projectile_x += projectile_hspeed;
        projectile_y += projectile_vspeed;

        // Screen wrapping
        if (projectile_x < 0 || projectile_x > room_width || projectile_y < 0 || projectile_y > room_height)
        {
            projectile_loops++;
            if (projectile_loops > projectile_max_loops)
            {
                projectile_active = false;
            }
            else
            {
                if (projectile_x < 0) projectile_x += room_width;
                if (projectile_x > room_width) projectile_x -= room_width;
                if (projectile_y < 0) projectile_y += room_height;
                if (projectile_y > room_height) projectile_y -= room_height;
            }
        }

        // Collision with players
        if (projectile_active)
        {
            var _count = instance_number(obj_player);
            for (var _i = 0; _i < _count; _i++)
            {
                var _p = instance_find(obj_player, _i);
                if (_p != noone && point_distance(projectile_x, projectile_y, _p.x, _p.y) < 20)
                {
                    if (_p.id == projectile_owner && projectile_shield_timer > 0) continue;
                    _p.hp -= 5;
                    // Knockback in projectile direction
                    var _kb = 3;
                    var _kdir = point_direction(0, 0, projectile_hspeed, projectile_vspeed);
                    _p.kb_x = lengthdir_x(_kb, _kdir);
                    _p.kb_y = lengthdir_y(_kb, _kdir);
                    _p.kb_timer = 4;
                    if (chosen_animal != "gravity") _p.slow_timer = 180;
                    achiev_hit_just_now = 120;
                    achiev_slow_hits = 0;
                    projectile_active = false;
                    break;
                }
            }
        }

        if (projectile_shield_timer > 0) projectile_shield_timer--;
    }

    // Poison dart movement (Thorn)
    if (poison_dart_active)
    {
        poison_dart_x += poison_dart_hspeed;
        poison_dart_y += poison_dart_vspeed;

        // Screen wrapping (loops once)
        if (poison_dart_x < 0 || poison_dart_x > room_width || poison_dart_y < 0 || poison_dart_y > room_height)
        {
            poison_dart_loops++;
            if (poison_dart_loops > poison_dart_max_loops)
            {
                poison_dart_active = false;
            }
            else
            {
                if (poison_dart_x < 0) poison_dart_x += room_width;
                if (poison_dart_x > room_width) poison_dart_x -= room_width;
                if (poison_dart_y < 0) poison_dart_y += room_height;
                if (poison_dart_y > room_height) poison_dart_y -= room_height;
            }
        }

        // Collision with players
        if (poison_dart_active)
        {
            var _count = instance_number(obj_player);
            for (var _i = 0; _i < _count; _i++)
            {
                var _p = instance_find(obj_player, _i);
                if (_p != noone && point_distance(poison_dart_x, poison_dart_y, _p.x, _p.y) < 20)
                {
                    if (_p.animal_type == "thorn")
                    {
                        _p.power_boost = 5 * 60;
                    }
                    else
                    {
                        _p.poison_timer = 4 * 60;
                    }
                    // Knockback in dart direction
                    var _kb = 3;
                    var _kdir = point_direction(0, 0, poison_dart_hspeed, poison_dart_vspeed);
                    _p.kb_x = lengthdir_x(_kb, _kdir);
                    _p.kb_y = lengthdir_y(_kb, _kdir);
                    _p.kb_timer = 4;
                    poison_dart_active = false;
                    break;
                }
            }
            }
        }
    }

    // Frog projectile movement (Dart Frog poison spit)
    if (frog_projectile_active)
    {
        frog_projectile_x += frog_projectile_hspeed;
        frog_projectile_y += frog_projectile_vspeed;
        if (frog_projectile_x < 0 || frog_projectile_x > room_width || frog_projectile_y < 0 || frog_projectile_y > room_height)
        {
            frog_projectile_active = false;
        }
        if (frog_projectile_active)
        {
            var _fc = instance_number(obj_player);
            for (var _fi = 0; _fi < _fc; _fi++)
            {
                var _fp = instance_find(obj_player, _fi);
                if (_fp != noone && _fp.id != frog_projectile_owner && point_distance(frog_projectile_x, frog_projectile_y, _fp.x, _fp.y) < 24)
                {
                    _fp.hp -= 5;
                    _fp.poison_timer = 180;
                    achiev_frog_poison_dmg += 5;
                    var _fkb = 3;
                    var _fkdir = point_direction(0, 0, frog_projectile_hspeed, frog_projectile_vspeed);
                    _fp.kb_x = lengthdir_x(_fkb, _fkdir);
                    _fp.kb_y = lengthdir_y(_fkb, _fkdir);
                    _fp.kb_timer = 4;
                    frog_projectile_active = false;
                    break;
                }
            }
        }
    }

    // Sprig slingshot movement
    if (sprig_slingshot_active)
    {
        sprig_slingshot_x += sprig_slingshot_hspeed;
        sprig_slingshot_y += sprig_slingshot_vspeed;
        if (sprig_slingshot_x < 0 || sprig_slingshot_x > room_width || sprig_slingshot_y < 0 || sprig_slingshot_y > room_height)
        {
            sprig_slingshot_loops++;
            if (sprig_slingshot_loops > sprig_slingshot_max_loops)
                sprig_slingshot_active = false;
            else
            {
                if (sprig_slingshot_x < 0) sprig_slingshot_x += room_width;
                if (sprig_slingshot_x > room_width) sprig_slingshot_x -= room_width;
                if (sprig_slingshot_y < 0) sprig_slingshot_y += room_height;
                if (sprig_slingshot_y > room_height) sprig_slingshot_y -= room_height;
            }
        }
        if (sprig_slingshot_active)
        {
            var _sc = instance_number(obj_player);
            for (var _si = 0; _si < _sc; _si++)
            {
                var _sp = instance_find(obj_player, _si);
                if (_sp != noone && _sp.id != sprig_slingshot_owner && point_distance(sprig_slingshot_x, sprig_slingshot_y, _sp.x, _sp.y) < 20)
                {
                    _sp.hp -= 5;
                    var _skb = 3;
                    var _skdir = point_direction(0, 0, sprig_slingshot_hspeed, sprig_slingshot_vspeed);
                    _sp.kb_x = lengthdir_x(_skb, _skdir);
                    _sp.kb_y = lengthdir_y(_skb, _skdir);
                    _sp.kb_timer = 4;
                    sprig_slingshot_active = false;
                    break;
                }
            }
        }
    }

    // Croak: Pond Frog reflects non-poison projectiles, catches poison ones
    // Check Barthemus projectile (reflect - not poison)
    if (projectile_active)
    {
        var _cc = instance_number(obj_player);
        for (var _ci = 0; _ci < _cc; _ci++)
        {
            var _cp = instance_find(obj_player, _ci);
            if (_cp != noone && _cp.croak_active && point_distance(projectile_x, projectile_y, _cp.x, _cp.y) < 40)
            {
                projectile_hspeed = -projectile_hspeed;
                projectile_vspeed = -projectile_vspeed;
                projectile_owner = _cp.id;
                projectile_shield_timer = 20;
                _cp.croak_active = false;
            }
        }
    }
    // Check Thorn poison dart (catch - is poison)
    if (poison_dart_active)
    {
        var _cc = instance_number(obj_player);
        for (var _ci = 0; _ci < _cc; _ci++)
        {
            var _cp = instance_find(obj_player, _ci);
            if (_cp != noone && _cp.croak_active && point_distance(poison_dart_x, poison_dart_y, _cp.x, _cp.y) < 40)
            {
                poison_dart_active = false;
                _cp.croak_active = false;
                with (_cp) croak_poison_caught_timer = 600;
                achiev_frog_croak_catch++;
                // Chameleon: catching a Thorn poison dart with croak unlocks Sprig
                if (achiev_frog_croak_catch >= 1) achiev_unlocked[10] = true;
            }
        }
    }
    // Check Dart Frog poison spit (catch - is poison)
    if (frog_projectile_active)
    {
        var _cc = instance_number(obj_player);
        for (var _ci = 0; _ci < _cc; _ci++)
        {
            var _cp = instance_find(obj_player, _ci);
            if (_cp != noone && _cp.croak_active && point_distance(frog_projectile_x, frog_projectile_y, _cp.x, _cp.y) < 40)
            {
                frog_projectile_active = false;
                _cp.croak_active = false;
                with (_cp) croak_poison_caught_timer = 600;
            }
        }
    }

    // Practice: middle-click context menu on ducks
    if (network_type == "none")
    {
        if (mouse_check_button_pressed(mb_middle))
        {
            var mx = device_mouse_x_to_gui(0);
            var my = device_mouse_y_to_gui(0);
            practice_context_duck = noone;
            var _count = instance_number(obj_player);
            for (var _i = 0; _i < _count; _i++)
            {
                var _p = instance_find(obj_player, _i);
                if (_p != noone && point_distance(mx, my, _p.x, _p.y) < 32)
                {
                    practice_context_duck = _p.id;
                    break;
                }
            }
        }

        // Context menu button clicks
        if (practice_context_duck != noone && instance_exists(practice_context_duck))
        {
            if (mouse_check_button_pressed(mb_left))
            {
                var mx = device_mouse_x_to_gui(0);
                var my = device_mouse_y_to_gui(0);
                var _d = practice_context_duck;
                var _cx = _d.x, _cy = _d.y;
                var _r = 18;
                var _gap = 30;

                // X (center) - close
                if (point_distance(mx, my, _cx, _cy) < _r)
                    practice_context_duck = noone;
                // Wander (above)
                else if (point_distance(mx, my, _cx, _cy - _gap) < _r)
                {
                    _d.ai_mode = "wander";
                    _d.ai_dir = irandom(3);
                    _d.ai_timer = 60 + irandom(60);
                    practice_context_duck = noone;
                }
                // Control (left) - only in ONE mode
                else if (!practice_all_mode && point_distance(mx, my, _cx - _gap, _cy) < _r)
                {
                    practice_controlled_duck = _d.id;
                    _d.ai_mode = "";
                    practice_context_duck = noone;
                    chosen_animal = _d.animal_type;
                    ability_name = "";
                    ability_active = false;
                    ability_timer = 0;
                    ability_cooldown_timer = 0;
                    projectile_active = false;
                    poison_dart_active = false;
                    breadcrumb_active = false;
                    mind_control_active = false;
                }
                // Copy (below) - toggle
                else if (point_distance(mx, my, _cx, _cy + _gap) < _r)
                {
                    _d.ai_mode = (_d.ai_mode == "copy") ? "" : "copy";
                    practice_context_duck = noone;
                }
                // Follow (right)
                else if (point_distance(mx, my, _cx + _gap, _cy) < _r)
                {
                    _d.ai_mode = "follow";
                    practice_context_duck = noone;
                }
            }
        }
    }
    
    // Achievement tracking timers
if (achiev_hit_just_now > 0) achiev_hit_just_now--;
if (achiev_dte_timer > 0) achiev_dte_timer--;

// Breadcrumb timer
if (breadcrumb_active)
{
    breadcrumb_timer--;
    if (breadcrumb_timer <= 0) breadcrumb_active = false;
}

// Breadcrumb gravitational pull on non-breadduck players
if (breadcrumb_active)
{
    var _count = instance_number(obj_player);
    for (var _i = 0; _i < _count; _i++)
    {
        var _p = instance_find(obj_player, _i);
        if (_p != noone && _p.animal_type != "breadduck")
        {
            var _dir = point_direction(_p.x, _p.y, breadcrumb_x, breadcrumb_y);
            var _dist = point_distance(_p.x, _p.y, breadcrumb_x, breadcrumb_y);
            if (_dist > 10)
            {
                _p.x += lengthdir_x(1.5, _dir);
                _p.y += lengthdir_y(1.5, _dir);
            }
        }
    }
}

// Achievement search input
if (screen_state == SCREEN_ACHIEVEMENTS && achiev_focused)
{
    var _key = keyboard_lastchar;
    if (_key != "")
    {
        if (string_length(achiev_search) < 20)
            achiev_search += _key;
        keyboard_lastchar = ""; // consume
    }
    if (keyboard_check_pressed(vk_backspace) && string_length(achiev_search) > 0)
    {
        achiev_search = string_copy(achiev_search, 1, string_length(achiev_search) - 1);
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape))
    {
        achiev_focused = false;
    }
}

// Achievement toast timer
if (achiev_toast_timer > 0) achiev_toast_timer--;

// Detect new achievement unlocks
for (var _ati = 0; _ati < achiev_count; _ati++)
{
    if (_ati == 9) continue;
    if (achiev_unlocked[_ati] && !achiev_toast_prev[_ati])
    {
        if (_ati == 4 || _ati == 10)
            achiev_toast_text = "Hidden Achievement " + achiev_name[_ati] + " Achieved!";
        else
            achiev_toast_text = "Achievement " + achiev_name[_ati] + " Achieved!";
        achiev_toast_timer = 5 * 60;
    }
    achiev_toast_prev[_ati] = achiev_unlocked[_ati];
}

// Frog achievement unlock checks
if (achiev_frog_poison_dmg >= 50) achiev_unlocked[5] = true;
if (achiev_frog_slam_dmg >= 100) achiev_unlocked[6] = true;
if (achiev_frog_tongue_hits >= 10) achiev_unlocked[7] = true;
if (achiev_frog_refract_hits >= 5) achiev_unlocked[8] = true;

input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));

Walking();