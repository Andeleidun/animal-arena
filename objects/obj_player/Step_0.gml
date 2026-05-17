input_up = keyboard_check(ord("W"));
input_down = keyboard_check(ord("S"));
input_left = keyboard_check(ord("A"));
input_right = keyboard_check(ord("D"));

if (input_up && !input_down)
{
    y -= 1;
}

if (input_down && !input_up)
{
    y += 1;
}

if (input_left && !input_right)
{
    x -= 1;
}

if (input_right && !input_left)
{
    x += 1;
}