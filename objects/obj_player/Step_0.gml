input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));

var _g = instance_find(obj_game, 0);
if (_g != noone && (_g.paused || _g.battle_over)) exit;
if (_g != noone && _g.network_type == "none" && _g.screen_state != _g.SCREEN_BATTLE) { instance_destroy(); exit; }

var _spd = 2;
var _gravity_active = false;
if (_g != noone && _g.ability_active && _g.chosen_animal == "gravity") _gravity_active = true;
if (animal_type == "gravity" && _gravity_active) _spd = 3;
if (animal_type != "gravity" && _gravity_active) _spd = 1;
if (slow_timer > 0) _spd = slow_speed;

var _is_frog = (animal_type == "frog" || animal_type == "dartfrog" || animal_type == "bullfrog" || animal_type == "treefrog" || animal_type == "glassfrog" || animal_type == "sprig");
if (_is_frog)
{
    if (animal_type == "treefrog" || animal_type == "sprig")
        _spd = 4;
    else if (animal_type != "bullfrog")
        _spd = 3;
}

// Practice mode: AI behaviors and ALL/ONE mode
var _is_practice = (_g != noone && _g.network_type == "none" && _g.screen_state == _g.SCREEN_BATTLE);
var _dx = 0, _dy = 0;
var _wasd_swing = true; // can this duck swing LMB?

if (_is_practice)
{
    // Determine WASD control
    var _wasd = false;
    if (_g.practice_all_mode)
    {
        _wasd = (ai_mode == "" || ai_mode == "copy");
        _wasd_swing = (ai_mode == "");
    }
    else
    {
        _wasd = (id == _g.practice_controlled_duck || ai_mode == "copy");
        _wasd_swing = (id == _g.practice_controlled_duck);
    }

    if (_wasd)
    {
        if (input_up && !input_down) _dy -= _spd;
        if (input_down && !input_up) _dy += _spd;
        if (input_left && !input_right) _dx -= _spd;
        if (input_right && !input_left) _dx += _spd;
    }

    // AI behaviors
    if (ai_mode == "wander")
    {
        ai_timer--;
        if (ai_timer <= 0)
        {
            ai_dir = irandom(3);
            ai_timer = 60 + irandom(60);
        }
        switch (ai_dir)
        {
            case 0: _dy -= _spd; break;
            case 1: _dy += _spd; break;
            case 2: _dx -= _spd; break;
            case 3: _dx += _spd; break;
        }
    }
    else if (ai_mode == "follow")
    {
        var _target = _g.practice_controlled_duck;
        if (_target != noone && instance_exists(_target))
        {
            var _dist = point_distance(x, y, _target.x, _target.y);
            if (_dist > 50)
            {
                var _dir = point_direction(x, y, _target.x, _target.y);
                _dx += lengthdir_x(_spd, _dir);
                _dy += lengthdir_y(_spd, _dir);
            }
        }
    }

    // AI sprite direction based on actual movement
    if (ai_mode != "" && (_dx != 0 || _dy != 0))
    {
        if (animal_type == "sprig") image_speed = 2; else if (animal_type == "treefrog") image_speed = 1.25; else image_speed = 1;
        if (abs(_dx) > abs(_dy))
        {
            if (_dx > 0)
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_right; break; case "bardarius": sprite_index = spr_bardarius_right; break; case "barthemus": sprite_index = spr_barthemus_right; break; case "thorn": sprite_index = spr_thorn_right; break; case "gravity": sprite_index = spr_gravity_right; break; case "breadduck": sprite_index = spr_bread_right; break; case "frog": sprite_index = spr_pond_right; break; case "dartfrog": sprite_index = spr_dartfrog_right; break; case "bullfrog": sprite_index = spr_bullfrog_right; break; case "treefrog": sprite_index = spr_treefrog_right; break; case "glassfrog": sprite_index = spr_glassfrog_right; break; case "sprig": sprite_index = spr_sprig_right; break; }
            else
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_left; break; case "bardarius": sprite_index = spr_bardarius_left; break; case "barthemus": sprite_index = spr_barthemus_left; break; case "thorn": sprite_index = spr_thorn_left; break; case "gravity": sprite_index = spr_gravity_left; break; case "breadduck": sprite_index = spr_bread_left; break; case "frog": sprite_index = spr_pond_left; break; case "dartfrog": sprite_index = spr_dartfrog_left; break; case "bullfrog": sprite_index = spr_bullfrog_left; break; case "treefrog": sprite_index = spr_treefrog_left; break; case "glassfrog": sprite_index = spr_glassfrog_left; break; case "sprig": sprite_index = spr_sprig_left; break; }
        }
        else
        {
            if (_dy > 0)
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_front; break; case "bardarius": sprite_index = spr_bardarius_front; break; case "barthemus": sprite_index = spr_barthemus_front; break; case "thorn": sprite_index = spr_thorn_front; break; case "gravity": sprite_index = spr_gravity_front; break; case "breadduck": sprite_index = spr_bread_front; break; case "frog": sprite_index = spr_pond_front; break; case "dartfrog": sprite_index = spr_dartfrog_front; break; case "bullfrog": sprite_index = spr_bullfrog_front; break; case "treefrog": sprite_index = spr_treefrog_front; break; case "glassfrog": sprite_index = spr_glassfrog_front; break; case "sprig": sprite_index = spr_sprig_front; break; }
            else if (_dy < 0)
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_back; break; case "bardarius": sprite_index = spr_bardarius_back; break; case "barthemus": sprite_index = spr_barthemus_back; break; case "thorn": sprite_index = spr_thorn_back; break; case "gravity": sprite_index = spr_gravity_back; break; case "breadduck": sprite_index = spr_bread_back; break; case "frog": sprite_index = spr_pond_back; break; case "dartfrog": sprite_index = spr_dartfrog_back; break; case "bullfrog": sprite_index = spr_bullfrog_back; break; case "treefrog": sprite_index = spr_treefrog_back; break; case "glassfrog": sprite_index = spr_glassfrog_back; break; case "sprig": sprite_index = spr_sprig_right; break; }
        }
    }
    else if (ai_mode != "")
    {
        image_speed = 0;
    }
}

else
{
    if (input_up && !input_down) _dy -= _spd;
    if (input_down && !input_up) _dy += _spd;
    if (input_left && !input_right) _dx -= _spd;
    if (input_right && !input_left) _dx += _spd;
}

// During mind control, only MegaMind can swing
if (_g != noone && _g.mind_control_active && animal_type != "megamind")
{
    _wasd_swing = false;
}

// Mind control: non-MegaMind ducks move with arrow keys
if (_g != noone && _g.mind_control_active && animal_type != "megamind")
{
    _dx = 0; _dy = 0;
    if (keyboard_check(vk_up)) _dy -= _spd;
    if (keyboard_check(vk_down)) _dy += _spd;
    if (keyboard_check(vk_left)) _dx -= _spd;
    if (keyboard_check(vk_right)) _dx += _spd;
    if (_dx != 0 || _dy != 0)
    {
        if (animal_type == "sprig") image_speed = 2; else if (animal_type == "treefrog") image_speed = 1.25; else image_speed = 1;
        if (abs(_dx) > abs(_dy))
        {
            if (_dx > 0)
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_right; break; case "bardarius": sprite_index = spr_bardarius_right; break; case "barthemus": sprite_index = spr_barthemus_right; break; case "thorn": sprite_index = spr_thorn_right; break; case "gravity": sprite_index = spr_gravity_right; break; case "breadduck": sprite_index = spr_bread_right; break; case "frog": sprite_index = spr_pond_right; break; case "dartfrog": sprite_index = spr_dartfrog_right; break; case "bullfrog": sprite_index = spr_bullfrog_right; break; case "treefrog": sprite_index = spr_treefrog_right; break; case "glassfrog": sprite_index = spr_glassfrog_right; break; case "sprig": sprite_index = spr_sprig_right; break; }
            else
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_left; break; case "bardarius": sprite_index = spr_bardarius_left; break; case "barthemus": sprite_index = spr_barthemus_left; break; case "thorn": sprite_index = spr_thorn_left; break; case "gravity": sprite_index = spr_gravity_left; break; case "breadduck": sprite_index = spr_bread_left; break; case "frog": sprite_index = spr_pond_left; break; case "dartfrog": sprite_index = spr_dartfrog_left; break; case "bullfrog": sprite_index = spr_bullfrog_left; break; case "treefrog": sprite_index = spr_treefrog_left; break; case "glassfrog": sprite_index = spr_glassfrog_left; break; case "sprig": sprite_index = spr_sprig_left; break; }
        }
        else
        {
            if (_dy > 0)
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_front; break; case "bardarius": sprite_index = spr_bardarius_front; break; case "barthemus": sprite_index = spr_barthemus_front; break; case "thorn": sprite_index = spr_thorn_front; break; case "gravity": sprite_index = spr_gravity_front; break; case "breadduck": sprite_index = spr_bread_front; break; case "frog": sprite_index = spr_pond_front; break; case "dartfrog": sprite_index = spr_dartfrog_front; break; case "bullfrog": sprite_index = spr_bullfrog_front; break; case "treefrog": sprite_index = spr_treefrog_front; break; case "glassfrog": sprite_index = spr_glassfrog_front; break; case "sprig": sprite_index = spr_sprig_front; break; }
            else
                switch (animal_type) { case "megamind": sprite_index = spr_megamindduck_back; break; case "bardarius": sprite_index = spr_bardarius_back; break; case "barthemus": sprite_index = spr_barthemus_back; break; case "thorn": sprite_index = spr_thorn_back; break; case "gravity": sprite_index = spr_gravity_back; break; case "breadduck": sprite_index = spr_bread_back; break; case "frog": sprite_index = spr_pond_back; break; case "dartfrog": sprite_index = spr_dartfrog_back; break; case "bullfrog": sprite_index = spr_bullfrog_back; break; case "treefrog": sprite_index = spr_treefrog_back; break; case "glassfrog": sprite_index = spr_glassfrog_back; break; case "sprig": sprite_index = spr_sprig_right; break; }
        }
    }
    else
    {
        image_speed = 0;
    }
}

// Bullfrog Body Slam movement
if (bullfrog_slam_active)
{
    bullfrog_slam_timer--;
    var _bdist = point_distance(x, y, bullfrog_slam_x, bullfrog_slam_y);
    if (_bdist < 10 || bullfrog_slam_timer <= 0)
    {
        bullfrog_slam_active = false;
        // AoE damage
        var _bc = instance_number(obj_player);
        for (var _bi = 0; _bi < _bc; _bi++)
        {
            var _bo = instance_find(obj_player, _bi);
            if (_bo != id && point_distance(x, y, _bo.x, _bo.y) < 50)
            {
                _bo.hp -= 8;
                if (_g != noone) _g.achiev_frog_slam_dmg += 8;
            }
        }
    }
    else
    {
        var _bdir = point_direction(x, y, bullfrog_slam_x, bullfrog_slam_y);
        var _bspd = _bdist / bullfrog_slam_timer;
        if (_bspd > 12) _bspd = 12;
        _dx = lengthdir_x(_bspd, _bdir);
        _dy = lengthdir_y(_bspd, _bdir);
    }
}

// Tree Frog Canopy Drop movement
if (treefrog_drop_active)
{
    treefrog_drop_timer--;
    if (point_distance(x, y, treefrog_drop_target_x, treefrog_drop_target_y) < 10 || treefrog_drop_timer <= 0)
    {
        x = treefrog_drop_target_x;
        y = treefrog_drop_target_y;
        treefrog_drop_active = false;
    }
    else
    {
        x += (treefrog_drop_target_x - x) * 0.4;
        y += (treefrog_drop_target_y - y) * 0.4;
    }
}

x += _dx;
y += _dy;

// Knockback movement
if (kb_timer > 0)
{
    x += kb_x;
    y += kb_y;
    kb_timer--;
    // Sprig fling damage tracking
    if (_g != noone && _g.sprig_fling_victim == id && kb_timer <= 0)
    {
        var _sdist = point_distance(_g.sprig_fling_start_x, _g.sprig_fling_start_y, x, y);
        var _sdmg = (_sdist / 75) * 1.5;
        if (_sdmg > 0) hp -= _sdmg;
        _g.sprig_fling_victim = noone;
    }
}

var _wrapped = false;
if (x < 0) { x += room_width; _wrapped = true; }
if (x > room_width) { x -= room_width; _wrapped = true; }
if (y < 0) { y += room_height; _wrapped = true; }
if (y > room_height) { y -= room_height; _wrapped = true; }

if (_wrapped)
{
    var _g = instance_find(obj_game, 0);
    if (_g != noone)
    {
        // Down to Earth: start window after any wrap
        _g.achiev_dte_timer = 60;

        // Back Again: wrapped after a hit
        if (_g.achiev_back_hit) _g.achiev_back_wrapped = true;

        if (_g.achiev_hit_just_now > 0)
        {
            _g.achiev_edge_loops++;
            if (_g.achiev_edge_loops >= _g.achiev_loop_req[0])
            {
                _g.achiev_unlocked[0] = true;
            }
        }
    }
}

if (slow_timer > 0) slow_timer--;

// Poison tick
if (poison_timer > 0)
{
    poison_timer--;
    if (poison_timer % 60 == 0 && poison_timer > 0) hp -= 5;
}
if (power_boost > 0) power_boost--;

var _context_open = (_g != noone && _g.practice_context_duck != noone);

// Check if grabbed by Sprig (no LMB while grappled)
var _grabbed = false;
var _pc = instance_number(obj_player);
for (var _pi = 0; _pi < _pc; _pi++)
{
    var _po = instance_find(obj_player, _pi);
    if (_po != noone && _po.sprig_grapple_target == id)
    {
        _grabbed = true;
        break;
    }
}

// Frog LMB: Sprig uses slingshot, others use tongue
if (_is_frog && mouse_check_button_pressed(mb_left) && !_context_open && !_grabbed)
{
    if (animal_type == "sprig")
    {
        // Fire slingshot
        if (sprig_slingshot_cooldown <= 0)
        {
            // Turn to face firing direction before animating
            var _fmx = device_mouse_x_to_gui(0);
            var _fmy = device_mouse_y_to_gui(0);
            var _fdx = _fmx - x;
            var _fdy = _fmy - y;
            if (abs(_fdx) > abs(_fdy))
            {
                if (_fdx > 0) sprite_index = spr_sprig_right;
                else sprite_index = spr_sprig_left;
            }
            else
            {
                if (_fdy > 0) sprite_index = spr_sprig_front;
                else sprite_index = spr_sprig_back;
            }
            sprig_slingshot_weapon_timer = 18;
            sprig_slingshot_weapon_frame = 0;
            sprig_slingshot_fired = false;
            sprig_slingshot_cooldown = 30;
        }
    }
    else if (!tongue_active && tongue_cooldown <= 0)
    {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _tdir = point_direction(x, y, _mx, _my);
        var _tdist = min(point_distance(x, y, _mx, _my), 150);
        tongue_active = true;
        tongue_phase = "extend";
        tongue_timer = 10;
        tongue_target_x = x + lengthdir_x(_tdist, _tdir);
        tongue_target_y = y + lengthdir_y(_tdist, _tdir);
        tongue_tip_x = x;
        tongue_tip_y = y;
        tongue_hit = false;
    }
}

if (mouse_check_button_pressed(mb_left) && !swing_active && swing_cooldown <= 0 && !_context_open && _wasd_swing && !_is_frog && !_grabbed)
{
    swing_active = true;
    swing_frame = -1;
    swing_accum = 0;
    swing_cooldown = 48;
    if (animal_type == "gravity" && _gravity_active) swing_cooldown = 30;
    swing_hit = false;
}

if (swing_active)
{
    swing_accum += 120 / 60;
    while (swing_accum >= 1)
    {
        swing_frame++;
        swing_accum -= 1;
        if (swing_frame >= swing_duration)
        {
            swing_active = false;
            break;
        }
    }
        if (swing_active && !swing_hit)
{
    var _count = instance_number(obj_player);
    for (var _i = 0; _i < _count; _i++)
    {
        var _other = instance_find(obj_player, _i);
        if (_other != id && point_distance(x, y, _other.x, _other.y) < 60)
        {
            var _dmg = swing_damage;
            if (_other.poison_timer > 0 && animal_type == "thorn") _dmg += 3;
            if (power_boost > 0) _dmg += 5;
            if (animal_type == "gravity" && _gravity_active) _dmg = 8;
            // Bullfrog thick skin: 20% reduction
            if (_other.animal_type == "bullfrog") _dmg = ceil(_dmg * 0.8);
            _other.hp -= _dmg;
            // Poison skin: Dart Frog always; Pond Frog after catching poison with croak
            if (_other.animal_type == "dartfrog" || (_other.animal_type == "frog" && _other.croak_poison_caught_timer > 0)) hp -= 2;
            swing_hit = true;

            // Knockback
            var _kb = 4;
            if (animal_type == "bardarius" || animal_type == "gravity") _kb = 6;
            var _dir = point_direction(x, y, _other.x, _other.y);
            _other.kb_x = lengthdir_x(_kb, _dir);
            _other.kb_y = lengthdir_y(_kb, _dir);
            _other.kb_timer = 6;

            // Gravity passive: slow opponent on hit (2s)
            if (animal_type == "gravity") _other.slow_timer = 120;

            if (_g != noone)
            {
                _g.achiev_hit_just_now = 120;
                if (_other.slow_timer > 0)
                {
                    _g.achiev_slow_hits++;
                    if (_g.achiev_slow_hits >= _g.achiev_slow_req[1])
                        _g.achiev_unlocked[1] = true;
                }
                // Down to Earth: hit within window after opponent wrap
                if (_g.achiev_dte_timer > 0)
                {
                    _g.achiev_dte_hits++;
                    if (_g.achiev_dte_hits >= _g.achiev_dte_req[2])
                        _g.achiev_unlocked[2] = true;
                    _g.achiev_dte_timer = 0;
                }

                // Over Here!: gravity lands a swing during gravity field
                if (_g.achiev_over_here_active && animal_type == "gravity")
                {
                    _g.achiev_over_here_swings++;
                    if (_g.achiev_over_here_swings >= _g.achiev_over_here_req[3] && !_g.achiev_over_here_broken)
                        _g.achiev_unlocked[3] = true;
                }

                // Over Here!: gravity (target) got hit during gravity field
                if (_g.achiev_over_here_active && _other.animal_type == "gravity")
                {
                    _g.achiev_over_here_broken = true;
                }

                // Back Again: hit → wrap → hit again
                if (_g.achiev_back_hit && _g.achiev_back_wrapped)
                {
                    _g.achiev_unlocked[4] = true;
                    _g.achiev_back_hit = false;
                    _g.achiev_back_wrapped = false;
                }
                else
                {
                    _g.achiev_back_hit = true;
                }
            }
            break;
        }
    }
}
}

// Death check (non-practice only)
if (hp <= 0 && _g != noone && _g.network_type != "none" && !_g.battle_over)
{
    _g.battle_over = true;
    _g.battle_text_y = -300;
    if (_g.local_player_id == id)
        _g.battle_result = "lose";
    else
        _g.battle_result = "win";
}

if (swing_cooldown > 0)
{
    swing_cooldown--;
}

// === FROG TONGUE UPDATE ===
if (tongue_active)
{
    tongue_timer--;
    if (tongue_phase == "extend")
    {
        tongue_tip_x += (tongue_target_x - tongue_tip_x) * 0.4;
        tongue_tip_y += (tongue_target_y - tongue_tip_y) * 0.4;
        if (point_distance(tongue_tip_x, tongue_tip_y, tongue_target_x, tongue_target_y) < 8 || tongue_timer <= 0)
        {
            tongue_phase = "retract";
            tongue_timer = 8;
        }
        if (!tongue_hit)
        {
            var _tc = instance_number(obj_player);
            for (var _ti = 0; _ti < _tc; _ti++)
            {
                var _to = instance_find(obj_player, _ti);
                if (_to != id && point_distance(tongue_tip_x, tongue_tip_y, _to.x, _to.y) < 30)
                {
                    var _tdmg = 3;
                    // Glass Frog boosted tongue
                    if (animal_type == "glassfrog" && glassfrog_refract_boost)
                    {
                        _tdmg = 10;
                        glassfrog_refract_boost = false;
                        if (_g != noone) _g.achiev_frog_refract_hits++;
                    }
                    _to.hp -= _tdmg;
                    tongue_hit = true;
                    // Dart Frog: tongue applies poison; Pond Frog after catching poison
                    if (animal_type == "dartfrog" || (animal_type == "frog" && croak_poison_caught_timer > 0)) _to.poison_timer = 120;
                    if (_g != noone) _g.achiev_frog_tongue_hits++;
                    break;
                }
            }
        }
    }
    else if (tongue_phase == "retract")
    {
        tongue_tip_x += (x - tongue_tip_x) * 0.3;
        tongue_tip_y += (y - tongue_tip_y) * 0.3;
        if (point_distance(tongue_tip_x, tongue_tip_y, x, y) < 8 || tongue_timer <= 0)
        {
            tongue_active = false;
            tongue_cooldown = 20;
        }
    }
}
if (tongue_cooldown > 0) tongue_cooldown--;

// Croak timer countdown
if (croak_active)
{
    croak_timer--;
    if (croak_timer <= 0) croak_active = false;
}
if (croak_cooldown > 0) croak_cooldown--;

// Croak poison buff timer
if (croak_poison_caught_timer > 0) croak_poison_caught_timer--;

// === FROG PASSIVE GIMMICKS ===
// Dart Frog: poison skin - enemies hitting with swing take 2 damage
if (animal_type == "dartfrog" && _g != noone)
{
    // Applied on hit in the swing damage section above
}
// Bullfrog: thick skin - 20% damage reduction applied on damage taken (handled in swing hit section)
// The damage is reduced when -hp is applied - we check in the damage section

// Tree Frog: 2x speed already applied above

// Glass Frog: Crystal Armor - absorbs first hit
if (animal_type == "glassfrog")
{
    if (glassfrog_refract_cooldown > 0) glassfrog_refract_cooldown--;
    if (glassfrog_refract_active)
    {
        glassfrog_refract_timer--;
        if (glassfrog_refract_timer <= 0)
        {
            glassfrog_refract_active = false;
            glassfrog_refract_boost = false;
        }
    }
}

// Sprig Tongue Grapple update
if (animal_type == "sprig" && sprig_grapple_target != noone)
{
    if (!instance_exists(sprig_grapple_target))
    {
        sprig_grapple_target = noone;
        sprig_grapple_timer = 0;
    }
    else
    {
        sprig_grapple_timer--;
        // Record previous position for fling velocity
        sprig_grapple_prev_x = sprig_grapple_last_x;
        sprig_grapple_prev_y = sprig_grapple_last_y;
        sprig_grapple_last_x = sprig_grapple_target.x;
        sprig_grapple_last_y = sprig_grapple_target.y;
        // Move grabbed target toward mouse (clamped to tongue range)
        var _smx = device_mouse_x_to_gui(0);
        var _smy = device_mouse_y_to_gui(0);
        var _sdir = point_direction(x, y, _smx, _smy);
        var _sdist = clamp(point_distance(x, y, _smx, _smy), 30, 500);
        var _stx = x + lengthdir_x(_sdist, _sdir);
        var _sty = y + lengthdir_y(_sdist, _sdir);
        sprig_grapple_target.x += (_stx - sprig_grapple_target.x) * 0.3;
        sprig_grapple_target.y += (_sty - sprig_grapple_target.y) * 0.3;
        // Prevent grabbed from moving
        sprig_grapple_target.kb_timer = 0;
        if (sprig_grapple_timer <= 0)
        {
            // Auto-release: squeeze only, no fling
            if (instance_exists(sprig_grapple_target))
                sprig_grapple_target.hp -= 8;
            sprig_grapple_target = noone;
            sprig_grapple_cooldown = 300; // 5s CD after release
        }
    }
}
if (sprig_grapple_cooldown > 0) sprig_grapple_cooldown--;

if (sprig_slingshot_cooldown > 0) sprig_slingshot_cooldown--;
if (sprig_slingshot_weapon_timer > 0)
{
    sprig_slingshot_weapon_timer--;
    if (sprig_slingshot_weapon_frame < 5) sprig_slingshot_weapon_frame++;

    // Fire projectile when release frame is reached
    if (sprig_slingshot_weapon_frame == 5 && !sprig_slingshot_fired)
    {
        var _smx = device_mouse_x_to_gui(0);
        var _smy = device_mouse_y_to_gui(0);
        var _sdir = point_direction(x, y, _smx, _smy);
        // Spawn from weapon tip position
        var _wox = 20, _woy = 0;
        if (sprite_index == spr_sprig_left) { _wox = -24; }
        else if (sprite_index == spr_sprig_back) { _wox = -10; _woy = -30; }
        else if (sprite_index == spr_sprig_front) { _wox = -10; _woy = 30; }
        if (_g != noone)
        {
            _g.sprig_slingshot_active = true;
            _g.sprig_slingshot_x = x + _wox;
            _g.sprig_slingshot_y = y + _woy;
            _g.sprig_slingshot_hspeed = lengthdir_x(12, _sdir);
            _g.sprig_slingshot_vspeed = lengthdir_y(12, _sdir);
            _g.sprig_slingshot_owner = id;
        }
        sprig_slingshot_fired = true;
    }
}