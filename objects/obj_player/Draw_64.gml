if (slow_timer > 0)
{
    draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, 0, make_color_rgb(120, 80, 140), 0.6);
}
else
{
    draw_self();
}

if (swing_active)
{
    var _ox = 0, _oy = 0;
    var _swing_sprite = spr_swing;
    var game = instance_find(obj_game, 0);
    var _weapon_angle = 0;
    if (game != noone && game.chosen_animal == "bardarius")
    {
        var t = min(1, swing_frame / 30);
        if (sprite_index == spr_bardarius_right)
        {
            _ox = 40; _weapon_angle = -20 + t * -50;
        }
        else if (sprite_index == spr_bardarius_left)
        {
            _ox = -40; _weapon_angle = 100 - t * -60;
        }
        else if (sprite_index == spr_bardarius_back)
        {
            _oy = -40; _weapon_angle = 70 + t * -50;
        }
        else
        {
            _oy = 40; _weapon_angle = -100 - t * 60;
        }
    }
    else
    {
        if (sprite_index == spr_megamindduck_right || sprite_index == spr_bardarius_right || sprite_index == spr_barthemus_right || sprite_index == spr_thorn_right || sprite_index == spr_gravity_right || sprite_index == spr_bread_right)
        {
            _swing_sprite = spr_swing; _ox = 40;
        }
        else if (sprite_index == spr_megamindduck_left || sprite_index == spr_bardarius_left || sprite_index == spr_barthemus_left || sprite_index == spr_thorn_left || sprite_index == spr_gravity_left || sprite_index == spr_bread_left)
        {
            _swing_sprite = spr_swing_left; _ox = -40;
        }
        else if (sprite_index == spr_megamindduck_back || sprite_index == spr_bardarius_back || sprite_index == spr_barthemus_back || sprite_index == spr_thorn_back || sprite_index == spr_gravity_back || sprite_index == spr_bread_back)
        {
            _swing_sprite = spr_swing_up; _oy = -40;
        }
        else
        {
            _swing_sprite = spr_swing_down; _oy = 40;
        }
    }

    var _sx = x + _ox;
    var _sy = y + _oy;
    if (_sx < 0) _sx += room_width;
    if (_sx > room_width) _sx -= room_width;
    if (_sy < 0) _sy += room_height;
    if (_sy > room_height) _sy -= room_height;

    if (game != noone && game.chosen_animal == "bardarius")
    {
        draw_sprite_ext(spr_bardarius_weapon, 0, _sx, _sy, 1, 1, _weapon_angle, c_white, 0.8);
        if (sprite_index == spr_bardarius_left)
        {
            draw_sprite_ext(spr_swing_left, swing_frame, _sx - 45, _sy, 1, 1, 0, c_white, 0.8);
        }
        else if (sprite_index == spr_bardarius_back)
        {
            draw_sprite_ext(spr_swing_up, swing_frame, _sx, _sy - 45, 1, 1, 0, c_white, 0.8);
        }
        else if (sprite_index == spr_bardarius_front)
        {
            draw_sprite_ext(spr_swing_down, swing_frame, _sx, _sy + 45, 1, 1, 0, c_white, 0.8);
        }
        else
        {
            draw_sprite_ext(spr_swing, swing_frame, _sx + 45, _sy, 1, 1, 0, c_white, 0.8);
        }
    }
    else
    {
        draw_sprite_ext(_swing_sprite, swing_frame, _sx, _sy, 1, 1, 0, c_white, 0.8);
    }
}

var game = instance_find(obj_game, 0);
if (game != noone && game.mind_control_active)
{
    var _m = 0.75, _xs = 1;
    var _xo = 0, _yo = 0;
    if (sprite_index == spr_megamindduck_front || sprite_index == spr_bardarius_front || sprite_index == spr_barthemus_front || sprite_index == spr_thorn_front || sprite_index == spr_gravity_front || sprite_index == spr_bread_front || sprite_index == spr_pond_front || sprite_index == spr_dartfrog_front || sprite_index == spr_bullfrog_front || sprite_index == spr_treefrog_front || sprite_index == spr_glassfrog_front || sprite_index == spr_sprig_front)
    {
        _m = 1;
    }
    else if (sprite_index == spr_megamindduck_back || sprite_index == spr_bardarius_back || sprite_index == spr_barthemus_back || sprite_index == spr_thorn_back || sprite_index == spr_gravity_back || sprite_index == spr_bread_back || sprite_index == spr_pond_back || sprite_index == spr_dartfrog_back || sprite_index == spr_bullfrog_back || sprite_index == spr_treefrog_back || sprite_index == spr_glassfrog_back || sprite_index == spr_sprig_right)
    {
        _m = 1.14; _xs = 1.18;
        _xo = -4;
        _yo = 8;
    }

    var _ap = 0.5 + 0.25 * sin(current_time * 0.004);
    var _frame = (current_time div 120) mod 4;
    draw_sprite_ext(spr_telekinesiscloud, _frame, _xo + x - 32, _yo + y - 14 - 32 * _m, _xs, _m, 0, c_white, _ap);
}

// Glass Frog: transparency during refraction
if (glassfrog_refract_active)
{
    draw_set_alpha(0.3);
    draw_self();
    draw_set_alpha(1);
}

// Frog tongue draw
if (tongue_active)
{
    draw_set_colour(c_red);
    draw_line_width(x, y, tongue_tip_x, tongue_tip_y, 3);
    draw_set_colour(c_white);
    draw_circle(tongue_tip_x, tongue_tip_y, 4, false);
}

// Sprig grapple line
if (sprig_grapple_target != noone && instance_exists(sprig_grapple_target))
{
    draw_set_colour(c_yellow);
    draw_line_width(x, y, sprig_grapple_target.x, sprig_grapple_target.y, 3);
    draw_set_colour(c_white);
}

// Sprig slingshot weapon draw
if (sprig_slingshot_weapon_timer > 0)
{
    var _wspr = spr_slingshot_right;
    var _wox = 20, _woy = 0;
    if (sprite_index == spr_sprig_left) { _wspr = spr_slingshot_left; _wox = -24; }
    else if (sprite_index == spr_sprig_back) { _wspr = spr_slingshot_up; _wox = -10; _woy = -30; }
    else if (sprite_index == spr_sprig_front) { _wspr = spr_slingshot_down; _wox = -10; _woy = 30; }
    var _wf = min(sprig_slingshot_weapon_frame, 5);
    draw_sprite_ext(_wspr, _wf, x + _wox, y + _woy, 1, 1, 0, c_white, 1);
}

// Gravity duck: pulsating purple aura
if (animal_type == "gravity")
{
    var _pulse = 0.08 + 0.04 * sin(current_time * 0.005);
    draw_set_colour(make_color_rgb(180, 40, 255));
    draw_set_alpha(_pulse);
    draw_circle(x, y, 30, false);
    draw_set_alpha(_pulse * 0.6);
    draw_circle(x, y, 42, false);
    draw_set_alpha(1);
}