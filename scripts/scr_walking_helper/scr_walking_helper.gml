// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Walking()
{
    with (obj_player)
    {
        var _is_practice = (other.network_type == "none" && other.screen_state == other.SCREEN_BATTLE);
        var _wasd_control = true;
        if (_is_practice)
        {
            if (other.practice_all_mode)
                _wasd_control = (ai_mode == "" || ai_mode == "copy");
            else
                _wasd_control = (id == other.practice_controlled_duck);
        }

        if (_wasd_control)
        {
            if (other.input_right || other.input_left || other.input_up || other.input_down)
            {
                if (animal_type == "sprig")
                    image_speed = 2;
                else if (animal_type == "treefrog")
                    image_speed = 1.25;
                else
                    image_speed = 1;
            }
            else
            {
                image_speed = 0
            }

            if (other.input_right)
            {
                switch (animal_type)
                {
                    case "megamind": sprite_index = spr_megamindduck_right; break;
                    case "bardarius": sprite_index = spr_bardarius_right; break;
                    case "barthemus": sprite_index = spr_barthemus_right; break;
                    case "thorn": sprite_index = spr_thorn_right; break;
                    case "gravity": sprite_index = spr_gravity_right; break;
                    case "breadduck": sprite_index = spr_bread_right; break;
                    case "frog": sprite_index = spr_pond_right; break;
                    case "dartfrog": sprite_index = spr_dartfrog_right; break;
                    case "bullfrog": sprite_index = spr_bullfrog_right; break;
                    case "treefrog": sprite_index = spr_treefrog_right; break;
                    case "glassfrog": sprite_index = spr_glassfrog_right; break;
                    case "sprig": sprite_index = spr_sprig_right; break;
                }
            }
            else if (other.input_left)
            {
                switch (animal_type)
                {
                    case "megamind": sprite_index = spr_megamindduck_left; break;
                    case "bardarius": sprite_index = spr_bardarius_left; break;
                    case "barthemus": sprite_index = spr_barthemus_left; break;
                    case "thorn": sprite_index = spr_thorn_left; break;
                    case "gravity": sprite_index = spr_gravity_left; break;
                    case "breadduck": sprite_index = spr_bread_left; break;
                    case "frog": sprite_index = spr_pond_left; break;
                    case "dartfrog": sprite_index = spr_dartfrog_left; break;
                    case "bullfrog": sprite_index = spr_bullfrog_left; break;
                    case "treefrog": sprite_index = spr_treefrog_left; break;
                    case "glassfrog": sprite_index = spr_glassfrog_left; break;
                    case "sprig": sprite_index = spr_sprig_left; break;
                }
            }
            else if (other.input_down)
            {
                switch (animal_type)
                {
                    case "megamind": sprite_index = spr_megamindduck_front; break;
                    case "bardarius": sprite_index = spr_bardarius_front; break;
                    case "barthemus": sprite_index = spr_barthemus_front; break;
                    case "thorn": sprite_index = spr_thorn_front; break;
                    case "gravity": sprite_index = spr_gravity_front; break;
                    case "breadduck": sprite_index = spr_bread_front; break;
                    case "frog": sprite_index = spr_pond_front; break;
                    case "dartfrog": sprite_index = spr_dartfrog_front; break;
                    case "bullfrog": sprite_index = spr_bullfrog_front; break;
                    case "treefrog": sprite_index = spr_treefrog_front; break;
                    case "glassfrog": sprite_index = spr_glassfrog_front; break;
                    case "sprig": sprite_index = spr_sprig_front; break;
                }
            }
            else if (other.input_up)
            {
                switch (animal_type)
                {
                    case "megamind": sprite_index = spr_megamindduck_back; break;
                    case "bardarius": sprite_index = spr_bardarius_back; break;
                    case "barthemus": sprite_index = spr_barthemus_back; break;
                    case "thorn": sprite_index = spr_thorn_back; break;
                    case "gravity": sprite_index = spr_gravity_back; break;
                    case "breadduck": sprite_index = spr_bread_back; break;
                    case "frog": sprite_index = spr_pond_back; break;
                    case "dartfrog": sprite_index = spr_dartfrog_back; break;
                    case "bullfrog": sprite_index = spr_bullfrog_back; break;
                    case "treefrog": sprite_index = spr_treefrog_back; break;
                    case "glassfrog": sprite_index = spr_glassfrog_back; break;
                    case "sprig": sprite_index = spr_sprig_back; break;
                }
            }
        }
    }
}

function network_send_animal()
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

function network_send_ready()
{
    var buffer = buffer_create(256, buffer_fixed, 1);
    buffer_write(buffer, buffer_string, "ready:" + chosen_animal);
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

function keybinds()
{
rollback_define_input(
{
        left: ord("A"),
        right: ord("D"),
        up: ord("W"),
        down: ord("S"),
});
}
