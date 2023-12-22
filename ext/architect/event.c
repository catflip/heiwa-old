#include "event.h"

VALUE poll_event(VALUE _self)
{
	SDL_Event e;
	int status = SDL_PollEvent(&e);

	if (status == 0)
	{
		return Qnil;
	}

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, to_sym("type"), INT2NUM(e.type));

	// Surely there is a better way...
	switch (e.type)
	{
	case SDL_WINDOWEVENT:
		rb_hash_aset(hash, to_sym("window_id"), INT2NUM(e.window.windowID));
		break;

	case SDL_MOUSEBUTTONDOWN:
	case SDL_MOUSEBUTTONUP:
		VALUE state;

		// Mouse button state
		if (e.type == SDL_MOUSEBUTTONDOWN)
			state = to_sym("down");
		else
			state = to_sym("up");

		rb_hash_aset(hash, to_sym("window_id"), INT2NUM(e.button.windowID));
		rb_hash_aset(hash, to_sym("state"), state);
		rb_hash_aset(hash, to_sym("button"), INT2NUM(e.button.button));
		rb_hash_aset(hash, to_sym("clicks"), INT2NUM(e.button.clicks));
		rb_hash_aset(hash, to_sym("x"), INT2NUM(e.button.x));
		rb_hash_aset(hash, to_sym("y"), INT2NUM(e.button.y));
		break;

	case SDL_MOUSEMOTION:
		rb_hash_aset(hash, to_sym("x"), INT2NUM(e.motion.x));
		rb_hash_aset(hash, to_sym("y"), INT2NUM(e.motion.y));
		rb_hash_aset(hash, to_sym("x_relative"), INT2NUM(e.motion.xrel));
		rb_hash_aset(hash, to_sym("y_relative"), INT2NUM(e.motion.yrel));
		break;

	default:
		return Qnil;
	}

	return hash;
}
