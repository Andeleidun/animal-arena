//Start Screen
if screen_state == SCREEN_START
{
	draw_set_colour(c_navy);
	draw_rectangle(0, 0, 1280, 720, false);
	draw_set_alpha(1)

	draw_set_colour(c_white)
	draw_set_font(Font1)
	draw_text(446, 117, "Animal Arena!");

	if (ui_button(446, 250, 325, 108, "Single Player"))
	{
		(screen_state) = SCREEN_CHOOSE_FIGHTER
	}

	if (ui_button(446, 649, 325, 108, "Settings"))
	{
		(screen_state) = SCREEN_OPTIONS
	}

	if (ui_button(900, 25, 325, 108, "Exit"))
	{
		game_end();
	}
}

//Choosing Fighter Screen
if screen_state == SCREEN_CHOOSE_FIGHTER
{
	draw_set_colour(c_navy);
	draw_rectangle(0, 0, 1280, 720, false);
	draw_set_alpha(1)

	draw_set_colour(c_white)
	draw_set_font(Font1)
	draw_text(410, 50, "Choose Your Fighter!");

	// Fighter selection grid
	draw_set_colour(c_aqua)
	draw_rectangle(50, 120, 280, 350, true)   // Fighter 1
	draw_rectangle(330, 120, 560, 350, true)  // Fighter 2
	draw_rectangle(610, 120, 840, 350, true)  // Fighter 3
	draw_rectangle(890, 120, 1120, 350, true) // Fighter 4

	draw_set_colour(c_white)
	draw_text(120, 250, "Fighter 1")
	draw_text(400, 250, "Fighter 2")
	draw_text(680, 250, "Fighter 3")
	draw_text(960, 250, "Fighter 4")

	// Fighter stats/info area
	draw_set_colour(c_grey)
	draw_rectangle(50, 400, 1235, 700, true)

	draw_set_colour(c_white)
	draw_text(60, 420, "Select a fighter to view stats")

	// Back button
	if (ui_button(25, 25, 325, 108, "Back"))
	{
		screen_state = SCREEN_START
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

	draw_set_alpha(0.30)
	draw_set_colour(c_navy);
	draw_rectangle(0, 0, 1280, 720, false);
	draw_set_alpha(1)

	draw_set_colour(c_white)
	draw_set_font(Font1)
	draw_text(446, 117, "Animal Arena!");

	if (ui_locked_button(446, 317, 325, 108, "Play"))
	{
		(screen_state) = SCREEN_CHOOSE_FIGHTER
	}

	if (ui_locked_button(446, 450, 325, 108, "Settings"))
	{
		(screen_state) = SCREEN_OPTIONS
	}

	if (ui_locked_button(446, 588, 325, 108, "Achievements"))
	{
		(screen_state) = SCREEN_ACHIEVEMENTS
	}

	draw_set_alpha(1)

	draw_set_colour(c_aqua)
	draw_rectangle(446, 117, 781, 558, false)
	
	draw_set_colour(c_blue)
	draw_rectangle(446, 117, 781, 558, true)
	
	draw_set_colour(c_white)
	draw_text(480, 200, "Achievements Coming Soon!")

	draw_set_colour(c_red)
	draw_rectangle(25, 25, 350, 133, false)

	draw_set_alpha(0.5)
	
	if (ui_button(25, 25, 325, 108, "Back"))
	{
		screen_state = SCREEN_START
	}
	
	draw_set_alpha(1)

	if (ui_button(900, 25, 325, 108, "Exit"))
	{
		game_end();
	}
}