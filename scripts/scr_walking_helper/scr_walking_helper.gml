// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Walking()
{
 if (input_right || input_left || input_up || input_down)
 {
	 with (obj_player)
	 {
		 image_speed = 1
	 }
 }
 else if (!input_right && !input_left && !input_up && !input_down)
 {
	 with (obj_player)
	 {
		 image_speed = 0
		 
		 if (other.chosen_animal == "bardarius")
		 {
			 if (sprite_index == -1)
			 {
				sprite_index = spr_bardarius_front
			 }
		 }
		 
		 if (other.chosen_animal == "barthemus")
		 {
			 if (sprite_index == -1)
			 {
				sprite_index = spr_barthemus_front
			 }
		 }
		 
		 if (other.chosen_animal == "megamind")
		 {
			 if (sprite_index == -1)
			 {
				sprite_index = spr_megamindduck_front
			 }
		 }
	 }
 }
 
 if (input_right)
 {
	 if (chosen_animal == "megamind")
	 {
		 object_set_sprite(obj_player, spr_megamindduck_right)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_right)
	 }
	 
	 if (chosen_animal == "barthemus")
	 {
		 object_set_sprite(obj_player, spr_barthemus_right)
	 }
 }
 
  if (input_left)
 {
	 if (chosen_animal == "megamind")
	 {
		 object_set_sprite(obj_player, spr_megamindduck_left)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_left)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_left)
	 }
 }
 
  if (input_down)
 {
	 if (chosen_animal == "megamind")
	 {
		 object_set_sprite(obj_player, spr_megamindduck_front)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_front)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_front)
	 }
 }
 
  if (input_up)
 {
	 if (chosen_animal == "megamind")
	 {
		 object_set_sprite(obj_player, spr_megamindduck_back)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_back)
	 }
	 
	 if (chosen_animal == "bardarius")
	 {
		 object_set_sprite(obj_player, spr_bardarius_back)
	 }
 }
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
