/*

This file contains methods adapted from the SDL2_gfxPrimitives library,
which was originally developed by Andreas Schiffler (aschiffler at ferzkopp dot net)
and modified by Richard Russell (richard at rtrussell dot co dot uk).

*/

#pragma once

#include <SDL2/SDL2_gfxPrimitives.h>

SDL2_GFXPRIMITIVES_SCOPE int aaFilledPolygonColor(SDL_Renderer *renderer, const double *vx, const double *vy, int n, Uint32 color);
SDL2_GFXPRIMITIVES_SCOPE int aaFilledPolygonRGBA(SDL_Renderer *renderer, const double *vx, const double *vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
SDL2_GFXPRIMITIVES_SCOPE int aaFilledPieColor(SDL_Renderer *renderer, float cx, float cy, float rx, float ry, float start, float end, Uint32 chord, Uint32 color);
SDL2_GFXPRIMITIVES_SCOPE int aaFilledPieRGBA(SDL_Renderer *renderer, float cx, float cy, float rx, float ry,
											 float start, float end, Uint32 chord, Uint8 r, Uint8 g, Uint8 b, Uint8 a);
