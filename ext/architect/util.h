#pragma once

#include <stdlib.h>
#include <SDL2/SDL.h>
#include <ruby.h>

void free_ptr(void *ptr);

// Gets the renderer pointer from an object.
SDL_Renderer* get_renderer(VALUE renderer);
