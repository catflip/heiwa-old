#include <stdio.h>
#include <ruby.h>
#include <SDL2/SDL.h>

#include "gfx.h"
#include "render.h"
#include "screen.h"
#include "event.h"

VALUE info()
{
	return rb_str_new_cstr("Pong!");
}

VALUE init_sdl()
{
	if (SDL_Init(SDL_INIT_VIDEO) != 0)
	{
		printf("Failed to initialize SDL: %s\n", SDL_GetError());
		rb_raise(rb_eRuntimeError, "Failed to initialize SDL");
	}

	return Qnil;
}

void Init_architect()
{
	VALUE architect = rb_define_module("Architect");

	rb_define_module_function(architect, "ping", info, 0);
	rb_define_module_function(architect, "init_sdl", init_sdl, 0);
	rb_define_module_function(architect, "set_hint", set_hint, 2);

	rb_define_module_function(architect, "create_window", create_window, 1);
	rb_define_module_function(architect, "create_renderer", create_renderer, 1);

	rb_define_module_function(architect, "render_delay", render_delay, 1);
	rb_define_module_function(architect, "render_clear", render_clear, 1);
	rb_define_module_function(architect, "render_present", render_present, 1);
	rb_define_module_function(architect, "render_draw_color", render_draw_color, 5);
	rb_define_module_function(architect, "render_rectangle", render_rectangle, 5);
	rb_define_module_function(architect, "render_rounded_rectangle", render_rounded_rectangle, 6);
	rb_define_module_function(architect, "render_cleanup", render_cleanup, 0);
	rb_define_module_function(architect, "poll_event", poll_event, 0);
	rb_define_module_function(architect, "get_ticks", get_ticks, 0);

	VALUE screen = rb_define_module("Screen");

	rb_define_module_function(screen, "size", screen_size, 1);
}
