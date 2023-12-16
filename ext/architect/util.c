#include "util.h"

void free_ptr(void* ptr) {
	free(ptr);
}

SDL_Renderer* get_renderer(VALUE renderer) {
	SDL_Renderer* rend;
	Data_Get_Struct(renderer, SDL_Renderer, rend);
	return rend;
}
