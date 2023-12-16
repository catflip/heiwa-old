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

VALUE set_hint(VALUE _self, VALUE n, VALUE v)
{
	Check_Type(n, T_STRING);
	Check_Type(v, T_STRING);

	char *name = StringValueCStr(n);
	char *value = StringValueCStr(v);

	SDL_SetHint(name, value);

	return Qnil;
}
