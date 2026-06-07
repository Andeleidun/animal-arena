var game = instance_find(obj_game, 0);
animal_type = "";
if (game != noone)
{
    animal_type = game.chosen_animal;
    switch (game.chosen_animal)
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

swing_active = false;
swing_frame = 0;
swing_accum = 0;
swing_duration = 52;
swing_cooldown = 0;
slow_timer = 0;
hp = 100;
slow_speed = 0.5;
if (animal_type == "barthemus") slow_speed = 1.2;
if (animal_type == "frog" || animal_type == "dartfrog" || animal_type == "bullfrog" || animal_type == "treefrog" || animal_type == "glassfrog" || animal_type == "sprig") slow_speed = 1;
poison_timer = 0;
power_boost = 0;
swing_hit = false;
kb_x = 0;
kb_y = 0;
kb_timer = 0;
var g = instance_find(obj_game, 0);
if (g != noone)
{
    switch (g.chosen_animal)
    {
        case "bardarius": swing_damage = 10; break;
        default: swing_damage = 5; break;
    }
}

// Frog tongue system
tongue_active = false;
tongue_phase = ""; // "extend", "retract"
tongue_timer = 0;
tongue_target_x = 0;
tongue_target_y = 0;
tongue_tip_x = 0;
tongue_tip_y = 0;
tongue_hit = false;
tongue_cooldown = 0;

// Frog croak system
croak_active = false;
croak_timer = 0;
croak_cooldown = 0;

// Dart Frog poison spit (uses projectile on obj_game, but tracking here)
dart_spit_cooldown = 0;

// Bullfrog slam
bullfrog_slam_active = false;
bullfrog_slam_x = 0;
bullfrog_slam_y = 0;
bullfrog_slam_timer = 0;
bullfrog_slam_cooldown = 0;

// Tree Frog canopy drop
treefrog_drop_active = false;
treefrog_drop_target_x = 0;
treefrog_drop_target_y = 0;
treefrog_drop_timer = 0;
treefrog_drop_cooldown = 0;

// Glass Frog refraction
glassfrog_refract_active = false;
glassfrog_refract_timer = 0;
glassfrog_refract_cooldown = 0;
glassfrog_refract_boost = false;

// Sprig tongue grapple
sprig_grapple_target = noone;
sprig_grapple_timer = 0;
sprig_grapple_cooldown = 0;
sprig_grapple_last_x = 0;
sprig_grapple_last_y = 0;
sprig_grapple_prev_x = 0;
sprig_grapple_prev_y = 0;

sprig_slingshot_cooldown = 0;
sprig_slingshot_weapon_timer = 0;
sprig_slingshot_weapon_frame = 0;
sprig_slingshot_fired = false;

croak_poison_caught_timer = 0;

ai_mode = "";
ai_dir = 0;
ai_timer = 0;
