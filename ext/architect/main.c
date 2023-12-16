#include <stdio.h>
#include <ruby.h>
#include <SDL2/SDL.h>

#include "render.h"

VALUE info()
{
	return rb_str_new_cstr("Pong!");
}

VALUE init_sdl()
{
	if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
	{
		printf("Failed to initialize SDL: %s\n", SDL_GetError());
		rb_raise(rb_eRuntimeError, "Failed to initialize SDL");
	}

	return Qnil;
}

void Init_architect()
{
	VALUE module = rb_define_module("Architect");

	rb_define_module_function(module, "ping", info, 0);
	rb_define_module_function(module, "init_sdl", init_sdl, 0);
	rb_define_module_function(module, "set_hint", set_hint, 2);

	rb_define_module_function(module, "create_window", create_window, 1);
	rb_define_module_function(module, "create_renderer", create_renderer, 1);

	rb_define_module_function(module, "render_clear", render_clear, 1);
	rb_define_module_function(module, "render_present", render_present, 1);
	rb_define_module_function(module, "render_draw_color", render_draw_color, 5);
	rb_define_module_function(module, "render_rectangle", render_rectangle, 5);
}
