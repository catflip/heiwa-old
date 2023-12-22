#include "util.h"

void free_ptr(void *ptr)
{
	free(ptr);
}

SDL_Renderer *get_renderer(VALUE renderer)
{
	SDL_Renderer *rend;
	Data_Get_Struct(renderer, SDL_Renderer, rend);
	return rend;
}

SDL_Window *get_window(VALUE window)
{
	SDL_Window *win;
	Data_Get_Struct(window, SDL_Window, win);
	return win;
}

VALUE set_hint(VALUE _self, VALUE n, VALUE v)
{
	Check_Type(n, T_STRING);
	Check_Type(v, T_STRING);

	char *name = StringValueCStr(n);
	char *value = StringValueCStr(v);

	SDL_SetHint(name, value);

	return Qnil;
}

VALUE to_sym(const char *str)
{
	return ID2SYM(rb_intern(str));
}
