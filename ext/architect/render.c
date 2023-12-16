#include "render.h"

VALUE create_window(VALUE _self, VALUE window_params)
{
	Check_Type(window_params, T_HASH);

	VALUE _title = rb_hash_aref(window_params, ID2SYM(rb_intern("title")));
	VALUE _x = rb_hash_aref(window_params, ID2SYM(rb_intern("x")));
	VALUE _y = rb_hash_aref(window_params, ID2SYM(rb_intern("y")));
	VALUE _width = rb_hash_aref(window_params, ID2SYM(rb_intern("width")));
	VALUE _height = rb_hash_aref(window_params, ID2SYM(rb_intern("height")));

	Check_Type(_title, T_STRING);
	Check_Type(_x, T_FIXNUM);
	Check_Type(_y, T_FIXNUM);
	Check_Type(_width, T_FIXNUM);
	Check_Type(_height, T_FIXNUM);

	char *title = StringValueCStr(_title);
	int x = NUM2INT(_x);
	int y = NUM2INT(_y);
	int width = NUM2INT(_width);
	int height = NUM2INT(_height);

	SDL_Window *window = SDL_CreateWindow(
		title,
		x, y,
		width, height,
		0);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, window);

	return object;
}

VALUE create_renderer(VALUE _self, VALUE window)
{
	SDL_Window *win;
	Data_Get_Struct(window, SDL_Window, win);

	SDL_Renderer *rend = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, rend);

	return object;
}

VALUE render_clear(VALUE _self, VALUE renderer)
{
	SDL_Renderer *rend = get_renderer(renderer);
	SDL_RenderClear(rend);

	return Qnil;
}

VALUE render_present(VALUE _self, VALUE renderer)
{
	SDL_Renderer *rend = get_renderer(renderer);
	SDL_RenderPresent(rend);

	return Qnil;
}

VALUE render_draw_color(VALUE _self, VALUE renderer, VALUE r, VALUE g, VALUE b, VALUE a)
{
	SDL_Renderer *rend = get_renderer(renderer);

	Check_Type(r, T_FIXNUM);
	Check_Type(g, T_FIXNUM);
	Check_Type(b, T_FIXNUM);
	Check_Type(a, T_FIXNUM);

	int red = NUM2INT(r);
	int green = NUM2INT(g);
	int blue = NUM2INT(b);
	int alpha = NUM2INT(a);

	SDL_SetRenderDrawColor(rend, red, green, blue, alpha);

	return Qnil;
}

VALUE render_rectangle(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE w, VALUE h)
{
	SDL_Renderer *rend = get_renderer(renderer);

	Check_Type(x, T_FIXNUM);
	Check_Type(y, T_FIXNUM);
	Check_Type(w, T_FIXNUM);
	Check_Type(h, T_FIXNUM);

	int pos_x = NUM2INT(x);
	int pos_y = NUM2INT(y);
	int width = NUM2INT(w);
	int height = NUM2INT(h);

	SDL_Rect rect = {pos_x, pos_y, width, height};

	SDL_RenderFillRect(rend, &rect);
}
