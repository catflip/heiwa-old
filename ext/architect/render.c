#include "render.h"

VALUE create_window(VALUE _self, VALUE window_params) {
	Check_Type(window_params, T_HASH);

	VALUE _title = rb_hash_aref(window_params, ID2SYM(rb_intern("title")));
	VALUE _width = rb_hash_aref(window_params, ID2SYM(rb_intern("width")));
	VALUE _height = rb_hash_aref(window_params, ID2SYM(rb_intern("height")));

	Check_Type(_title, T_STRING);
	Check_Type(_width, T_FIXNUM);
	Check_Type(_height, T_FIXNUM);

	char* title = StringValueCStr(_title);
	int width = NUM2INT(_width);
	int height = NUM2INT(_height);

	SDL_Window *window = SDL_CreateWindow(
		title,
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		width, height,
		0
	);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, window);

	return object;
}

VALUE create_renderer(VALUE _self, VALUE window) {
	SDL_Window *win;
	Data_Get_Struct(window, SDL_Window, win);

	SDL_Renderer *rend = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, rend);

	return object;
}

VALUE render_clear(VALUE _self, VALUE renderer) {
	SDL_Renderer* rend = get_renderer(renderer);
	SDL_RenderClear(rend);

	return Qnil;
}

VALUE render_present(VALUE _self, VALUE renderer) {
	SDL_Renderer* rend = get_renderer(renderer);
	SDL_RenderPresent(rend);

	return Qnil;
}
