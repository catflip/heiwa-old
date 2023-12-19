/*

This file contains methods adapted from the SDL2_gfxPrimitives library,
which was originally developed by Andreas Schiffler (aschiffler at ferzkopp dot net)
and modified by Richard Russell (richard at rtrussell dot co dot uk).

*/

#include "gfx.h"

// This constant determines the maximum size and/or complexity of polygon that can be
// drawn. Set to 16K the maximum aaArc height is approximately 1100 lines.
#define POLYSIZE 16384

static int _gfxPrimitivesCompareFloat2(const void *a, const void *b)
{
	float diff = *((float *)a + 1) - *((float *)b + 1);
	if (diff != 0.0)
		return (diff > 0) - (diff < 0);
	diff = *(float *)a - *(float *)b;
	return (diff > 0) - (diff < 0);
}

/*!
\brief Draw anti-aliased filled polygon with alpha blending.

\param renderer The renderer to draw on.
\param vx Vertex array containing X coordinates of the points of the filled polygon.
\param vy Vertex array containing Y coordinates of the points of the filled polygon.
\param n Number of points in the vertex array. Minimum number is 3.
\param r The red value of the filled polygon to draw.
\param g The green value of the filled polygon to draw.
\param b The blue value of the filed polygon to draw.
\param a The alpha value of the filled polygon to draw.

\returns Returns 0 on success, -1 on failure, or -2 if the polygon is too large and/or complex.
*/
int aaFilledPolygonRGBA(SDL_Renderer *renderer, const double *vx, const double *vy, int n, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
	int i, j, xi, yi, result;
	double x1, x2, y0, y1, y2, minx, maxx, prec;
	float *list, *strip;

	if (n < 3)
		return -1;

	result = SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);

	// Find extrema:
	minx = 99999.0;
	maxx = -99999.0;
	prec = 0.00001;
	for (i = 0; i < n; i++)
	{
		double x = vx[i];
		double y = fabs(vy[i]);
		if (x < minx)
			minx = x;
		if (x > maxx)
			maxx = x;
		if (y > prec)
			prec = y;
	}
	minx = floor(minx);
	maxx = floor(maxx);
	prec = floor(pow(2, 19) / prec);

	// Allocate main array, this determines the maximum polygon size and complexity:
	list = (float *)malloc(POLYSIZE * sizeof(float));
	if (list == NULL)
		return -2;

	// Build vertex list.  Special x-values used to indicate vertex type:
	// x = -100001.0 indicates /\, x = -100003.0 indicates \/, x = -100002.0 neither
	yi = 0;
	y0 = floor(vy[n - 1] * prec) / prec;
	y1 = floor(vy[0] * prec) / prec;
	for (i = 1; i <= n; i++)
	{
		if (yi > POLYSIZE - 4)
		{
			free(list);
			return -2;
		}
		y2 = floor(vy[i % n] * prec) / prec;
		if (((y1 < y2) - (y1 > y2)) == ((y0 < y1) - (y0 > y1)))
		{
			list[yi++] = -100002.0;
			list[yi++] = y1;
			list[yi++] = -100002.0;
			list[yi++] = y1;
		}
		else
		{
			if (y0 != y1)
			{
				list[yi++] = (y1 < y0) - (y1 > y0) - 100002.0;
				list[yi++] = y1;
			}
			if (y1 != y2)
			{
				list[yi++] = (y1 < y2) - (y1 > y2) - 100002.0;
				list[yi++] = y1;
			}
		}
		y0 = y1;
		y1 = y2;
	}
	xi = yi;

	// Sort vertex list:
	qsort(list, yi / 2, sizeof(float) * 2, _gfxPrimitivesCompareFloat2);

	// Append line list to vertex list:
	for (i = 1; i <= n; i++)
	{
		double x, y;
		double d = 0.5 / prec;

		x1 = vx[i - 1];
		y1 = floor(vy[i - 1] * prec) / prec;
		x2 = vx[i % n];
		y2 = floor(vy[i % n] * prec) / prec;

		if (y2 < y1)
		{
			double tmp;
			tmp = x1;
			x1 = x2;
			x2 = tmp;
			tmp = y1;
			y1 = y2;
			y2 = tmp;
		}
		if (y2 != y1)
			y0 = (x2 - x1) / (y2 - y1);

		for (j = 1; j < xi; j += 4)
		{
			y = list[j];
			if (((y + d) <= y1) || (y == list[j + 4]))
				continue;
			if ((y -= d) >= y2)
				break;
			if (yi > POLYSIZE - 4)
			{
				free(list);
				return -2;
			}
			if (y > y1)
			{
				list[yi++] = x1 + y0 * (y - y1);
				list[yi++] = y;
			}
			y += d * 2.0;
			if (y < y2)
			{
				list[yi++] = x1 + y0 * (y - y1);
				list[yi++] = y;
			}
		}

		y = floor(y1) + 1.0;
		while (y <= y2)
		{
			x = x1 + y0 * (y - y1);
			if (yi > POLYSIZE - 2)
			{
				free(list);
				return -2;
			}
			list[yi++] = x;
			list[yi++] = y;
			y += 1.0;
		}
	}

	// Sort combined list:
	qsort(list, yi / 2, sizeof(float) * 2, _gfxPrimitivesCompareFloat2);

	// Plot lines:
	strip = (float *)malloc((maxx - minx + 2) * sizeof(float));
	if (strip == NULL)
	{
		free(list);
		return -1;
	}
	memset(strip, 0, (maxx - minx + 2) * sizeof(float));
	n = yi;
	yi = list[1];
	j = 0;

	for (i = 0; i < n - 7; i += 4)
	{
		float x1 = list[i + 0];
		float y1 = list[i + 1];
		float x3 = list[i + 2];
		float x2 = list[i + j + 0];
		float y2 = list[i + j + 1];
		float x4 = list[i + j + 2];

		if (x1 + x3 == -200002.0)
			j += 4;
		else if (x1 + x3 == -200006.0)
			j -= 4;
		else if ((x1 >= minx) && (x2 >= minx))
		{
			if (x1 > x2)
			{
				float tmp = x1;
				x1 = x2;
				x2 = tmp;
			}
			if (x3 > x4)
			{
				float tmp = x3;
				x3 = x4;
				x4 = tmp;
			}

			for (xi = x1 - minx; xi <= x4 - minx; xi++)
			{
				float u, v;
				float x = minx + xi;
				if (x < x2)
					u = (x - x1 + 1) / (x2 - x1 + 1);
				else
					u = 1.0;
				if (x >= x3 - 1)
					v = (x4 - x) / (x4 - x3 + 1);
				else
					v = 1.0;
				if ((u > 0.0) && (v > 0.0))
					strip[xi] += (y2 - y1) * (u + v - 1.0);
			}
		}

		if ((yi == (list[i + 5] - 1.0)) || (i == n - 8))
		{
			for (xi = 0; xi <= maxx - minx; xi++)
			{
				if (strip[xi] != 0.0)
				{
					if (strip[xi] >= 0.996)
					{
						int x0 = xi;
						while (strip[++xi] >= 0.996)
							;
						xi--;
						result |= SDL_SetRenderDrawColor(renderer, r, g, b, a);
						result |= SDL_RenderDrawLine(renderer, minx + x0, yi, minx + xi, yi);
					}
					else
					{
						result |= SDL_SetRenderDrawColor(renderer, r, g, b, a * strip[xi]);
						result |= SDL_RenderDrawPoint(renderer, minx + xi, yi);
					}
				}
			}
			memset(strip, 0, (maxx - minx + 2) * sizeof(float));
			yi++;
		}
	}

	// Free arrays:
	free(list);
	free(strip);
	return result;
}

// returns Returns 0 on success, -1 on failure.
int aaFilledPolygonColor(SDL_Renderer *renderer, const double *vx, const double *vy, int n, Uint32 color)
{
	Uint8 *c = (Uint8 *)&color;
	return aaFilledPolygonRGBA(renderer, vx, vy, n, c[0], c[1], c[2], c[3]);
}

/*!
\brief Draw anti-aliased filled ellipical pie (or chord) with alpha blending.

\param renderer The renderer to draw on.
\param cx X coordinate of the center of the filled pie.
\param cy Y coordinate of the center of the filled pie.
\param rx Horizontal radius in pixels of the filled pie.
\param ry Vertical radius in pixels of the filled pie.
\param start Starting angle in degrees of the filled pie; zero is right, increasing clockwise.
\param end Ending angle in degrees of the filled pie; zero is right, increasing clockwise.
\param chord Set to 0 for a pie (sector) or 1 for a chord (segment).
\param r The red value of the filled pie to draw.
\param g The green value of the filled pie to draw.
\param b The blue value of the filled pie to draw.
\param a The alpha value of the filled pie to draw.
/
\returns Returns 0 on success, -1 on failure.
*/
int aaFilledPieRGBA(SDL_Renderer *renderer, float cx, float cy, float rx, float ry,
					float start, float end, Uint32 chord, Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
	int nverts, i, result;
	double *vx, *vy;

	// Sanity check radii
	if ((rx <= 0) || (ry <= 0) || (start == end))
		return -1;

	// Convert degrees to radians
	start = fmod(start, 360.0) * 2.0 * M_PI / 360.0;
	end = fmod(end, 360.0) * 2.0 * M_PI / 360.0;
	while (start >= end)
		end += 2.0 * M_PI;

	// Calculate number of vertices on perimeter
	nverts = (end - start) * sqrt(rx * ry) / M_PI;
	if (nverts < 2)
		nverts = 2;
	if (nverts > 180)
		nverts = 180;

	// Allocate combined vertex array
	vx = vy = (double *)malloc(2 * sizeof(double) * (nverts + 1));
	if (vx == NULL)
		return (-1);

	// Update pointer to start of vy
	vy += nverts + 1;

	// Calculate vertices:
	for (i = 0; i < nverts; i++)
	{
		double angle = start + (end - start) * (double)i / (double)(nverts - 1);
		vx[i] = cx + rx * cos(angle);
		vy[i] = cy + ry * sin(angle);
	}

	// Center:
	vx[i] = cx;
	vy[i] = cy;

	result = aaFilledPolygonRGBA(renderer, vx, vy, nverts + 1 - (chord != 0), r, g, b, a);

	// Free combined vertex array
	free(vx);

	return (result);
}

// returns Returns 0 on success, -1 on failure.
int aaFilledPieColor(SDL_Renderer *renderer, float cx, float cy, float rx, float ry, float start, float end, Uint32 chord, Uint32 color)
{
	Uint8 *c = (Uint8 *)&color;
	return aaFilledPieRGBA(renderer, cx, cy, rx, ry, start, end, chord, c[0], c[1], c[2], c[3]);
}
