function ui_button(_x, _y, _w, _h, _text)
{
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var hover = mx >= _x && mx <= _x + _w && my >= _y && my <= _y + _h;

    draw_set_color(hover ? make_color_rgb(80, 150, 220) : make_color_rgb(35, 50, 70));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
	draw_set_font(Font1);
    draw_text(_x + _w * 0.5, _y + _h * 0.5, _text);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    return hover && mouse_check_button_pressed(mb_left);
}

function ui_locked_button(_x, _y, _w, _h, _text)
{
    draw_set_color(make_color_rgb(24, 32, 44));
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(120, 130, 145));
    draw_text(_x + _w * 0.5, _y + _h * 0.5, _text);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}