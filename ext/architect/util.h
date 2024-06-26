#pragma once

#include <stdlib.h>
#include <SDL2/SDL.h>
#include <ruby.h>

void free_ptr(void *ptr);

// Gets the renderer pointer from an object.
SDL_Renderer *get_renderer(VALUE renderer);

// Gets the window pointer from an object.
SDL_Window *get_window(VALUE window);

// Set an SDL hint
VALUE set_hint(VALUE _self, VALUE n, VALUE v);

// Automatically create a symbol from a string
VALUE to_sym(const char *str);

// Get millis since start
VALUE get_ticks();
