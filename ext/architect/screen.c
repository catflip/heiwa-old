#include "screen.h"

VALUE screen_size(VALUE _self, VALUE display_index)
{
	Check_Type(display_index, T_FIXNUM);

	int index = NUM2INT(display_index);

	SDL_DisplayMode dm;
	SDL_GetCurrentDisplayMode(index, &dm);

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, to_sym("width"), INT2NUM(dm.w));
	rb_hash_aset(hash, to_sym("height"), INT2NUM(dm.h));

	return hash;
}
