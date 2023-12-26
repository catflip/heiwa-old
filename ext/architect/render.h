#pragma once

#include <ruby.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL2_gfxPrimitives.h>
#include <SDL2/SDL_ttf.h>

#include "util.h"
#include "gfx.h"

struct WINDOW_PARAMS
{
	char *title;
	int width;
	int height;
};

// Creates an SDL window, and returns the pointer.
VALUE create_window(VALUE _self, VALUE window_params);

// Creates a renderer for a window, and returns the pointer.
VALUE create_renderer(VALUE _self, VALUE window);

// Opens and returns an SDL font
VALUE open_font(VALUE _self, VALUE font, VALUE size);

// Closes an SDL font
VALUE close_font(VALUE _self, VALUE font_obj);

// Returns the size of a font
int* font_size(TTF_Font *font, const char* text);

// Renders text
VALUE render_text(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE content, VALUE font);

// Runs `SDL_Delay`
VALUE render_delay(VALUE _self, VALUE d);

// Runs `SDL_RenderClear`
VALUE render_clear(VALUE _self, VALUE renderer);

// Runs `SDL_RenderPresent`
VALUE render_present(VALUE _self, VALUE renderer);

// Runs `SDL_SetRenderDrawColor`
VALUE render_draw_color(VALUE _self, VALUE renderer, VALUE r, VALUE g, VALUE b, VALUE a);

// Runs `SDL_FillRect`
VALUE render_rectangle(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE w, VALUE h);

// Renders text

// Draws a rounded rectangle.
VALUE render_rounded_rectangle(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE w, VALUE h, VALUE rad);

// Cleans up window and renderers
VALUE render_cleanup(VALUE _self, VALUE window, VALUE renderer);
