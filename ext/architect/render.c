#include "render.h"

VALUE create_window(VALUE _self, VALUE window_params)
{
	Check_Type(window_params, T_HASH);

	VALUE _title = rb_hash_aref(window_params, to_sym("title"));
	VALUE _x = rb_hash_aref(window_params, to_sym("x"));
	VALUE _y = rb_hash_aref(window_params, to_sym("y"));
	VALUE _width = rb_hash_aref(window_params, to_sym("width"));
	VALUE _height = rb_hash_aref(window_params, to_sym("height"));

	Check_Type(_title, T_STRING);
	Check_Type(_x, T_FIXNUM);
	Check_Type(_y, T_FIXNUM);
	Check_Type(_width, T_FIXNUM);
	Check_Type(_height, T_FIXNUM);

	char *title = StringValueCStr(_title);
	int x = NUM2INT(_x);
	int y = NUM2INT(_y);
	int width = NUM2INT(_width);
	int height = NUM2INT(_height);

	SDL_Window *window = SDL_CreateWindow(
		title,
		x, y,
		width, height,
		0);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, window);

	return object;
}

VALUE create_renderer(VALUE _self, VALUE window)
{
	SDL_Window *win;
	Data_Get_Struct(window, SDL_Window, win);

	SDL_Renderer *rend = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);
	SDL_SetRenderDrawBlendMode(rend, SDL_BLENDMODE_BLEND);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, rend);

	return object;
}

VALUE text_width(VALUE _self, VALUE font, VALUE text)
{
	Check_Type(text, T_STRING);

	TTF_Font *ttf_font;
	Data_Get_Struct(font, TTF_Font, ttf_font);

	int w;
	TTF_SizeText(ttf_font, StringValueCStr(text), &w, NULL);

	return INT2NUM(w);
}

VALUE text_height(VALUE _self, VALUE font, VALUE text)
{
	Check_Type(text, T_STRING);

	TTF_Font *ttf_font;
	Data_Get_Struct(font, TTF_Font, ttf_font);

	int h;
	TTF_SizeText(ttf_font, StringValueCStr(text), NULL, &h);

	return INT2NUM(h);
}

int *font_size(TTF_Font *font, const char *text)
{
	int w, h;
	TTF_SizeText(font, text, &w, &h);

	int *size = malloc(sizeof(int) * 2);
	size[0] = w;
	size[1] = h;

	return size;
}

VALUE open_font(VALUE _self, VALUE font, VALUE size)
{
	Check_Type(font, T_STRING);
	Check_Type(size, T_FIXNUM);

	const char *font_path = StringValueCStr(font);
	int font_size = NUM2INT(size);

	TTF_Font *ttf_font = TTF_OpenFont(font_path, font_size);

	VALUE object = Data_Wrap_Struct(rb_cObject, 0, free_ptr, ttf_font);

	return object;
}

VALUE close_font(VALUE _self, VALUE font_obj)
{
	TTF_Font *font;
	Data_Get_Struct(font_obj, TTF_Font, font);

	TTF_CloseFont(font);

	return Qnil;
};

VALUE render_text(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE content, VALUE font_obj)
{
	Check_Type(x, T_FIXNUM);
	Check_Type(y, T_FIXNUM);
	Check_Type(content, T_STRING);

	SDL_Renderer *rend = get_renderer(renderer);

	int pos_x = NUM2INT(x);
	int pos_y = NUM2INT(y);

	SDL_Color color;
	SDL_GetRenderDrawColor(rend, &color.r, &color.g, &color.b, &color.a);

	TTF_Font *font;
	Data_Get_Struct(font_obj, TTF_Font, font);

	const char *text = StringValueCStr(content);

	SDL_Surface *surface = TTF_RenderText_Blended(font, text, color);
	SDL_Texture *texture = SDL_CreateTextureFromSurface(rend, surface);

	int *size = font_size(font, text);
	SDL_Rect rect = {pos_x, pos_y, size[0], size[1]};

	SDL_RenderCopy(rend, texture, NULL, &rect);

	SDL_FreeSurface(surface);
	SDL_DestroyTexture(texture);

	return Qnil;
}

VALUE render_delay(VALUE _self, VALUE d)
{
	int delay = NUM2INT(d);
	SDL_Delay(delay);
}

VALUE render_clear(VALUE _self, VALUE renderer)
{
	SDL_Renderer *rend = get_renderer(renderer);
	SDL_RenderClear(rend);

	return Qnil;
}

VALUE render_present(VALUE _self, VALUE renderer)
{
	SDL_Renderer *rend = get_renderer(renderer);
	SDL_RenderPresent(rend);

	return Qnil;
}

VALUE render_draw_color(VALUE _self, VALUE renderer, VALUE r, VALUE g, VALUE b, VALUE a)
{
	SDL_Renderer *rend = get_renderer(renderer);

	Check_Type(r, T_FIXNUM);
	Check_Type(g, T_FIXNUM);
	Check_Type(b, T_FIXNUM);
	Check_Type(a, T_FIXNUM);

	int red = NUM2INT(r);
	int green = NUM2INT(g);
	int blue = NUM2INT(b);
	int alpha = NUM2INT(a);

	SDL_SetRenderDrawColor(rend, red, green, blue, alpha);

	return Qnil;
}

VALUE render_rectangle(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE w, VALUE h)
{
	SDL_Renderer *rend = get_renderer(renderer);

	Check_Type(x, T_FIXNUM);
	Check_Type(y, T_FIXNUM);
	Check_Type(w, T_FIXNUM);
	Check_Type(h, T_FIXNUM);

	int pos_x = NUM2INT(x);
	int pos_y = NUM2INT(y);
	int width = NUM2INT(w);
	int height = NUM2INT(h);

	SDL_Rect rect = {pos_x, pos_y, width, height};

	SDL_RenderFillRect(rend, &rect);
}

VALUE render_rounded_rectangle(VALUE _self, VALUE renderer, VALUE x, VALUE y, VALUE w, VALUE h, VALUE rad)
{
	SDL_Renderer *rend = get_renderer(renderer);

	Check_Type(x, T_FIXNUM);
	Check_Type(y, T_FIXNUM);
	Check_Type(w, T_FIXNUM);
	Check_Type(h, T_FIXNUM);
	Check_Type(rad, T_FIXNUM);

	int pos_x = NUM2INT(x);
	int pos_y = NUM2INT(y);
	int width = NUM2INT(w);
	int height = NUM2INT(h);
	int radius = NUM2INT(rad);

	Uint8 r, g, b, a;
	SDL_GetRenderDrawColor(rend, &r, &g, &b, &a);

	int pies[4][5] = {
		{pos_x + radius, pos_y + radius, radius, -180, -90},
		{pos_x + width - radius, pos_y + radius, radius, -90, 0},
		{pos_x + radius, pos_y + height - radius, radius, -270, -180},
		{pos_x + width - radius, pos_y + height - radius, radius, 0, 90},
	};

	for (size_t i = 0; i < sizeof(pies) / sizeof(pies[0]); i++)
	{
		aaFilledPieRGBA(rend, pies[i][0], pies[i][1], pies[i][2], pies[i][2], pies[i][3], pies[i][4], 0, r, g, b, a);
	}

	// We need to deduct a single pixel from the width and height for some reason??
	int boxes[2][4] = {
		{pos_x, pos_y + radius, pos_x + width - 1, pos_y + height - radius},
		{pos_x + radius, pos_y, pos_x + width - radius, pos_y + height - 1}};

	for (size_t i = 0; i < sizeof(boxes) / sizeof(boxes[0]); i++)
	{
		boxRGBA(rend, boxes[i][0], boxes[i][1], boxes[i][2], boxes[i][3], r, g, b, a);
	}
};

VALUE render_cleanup(VALUE _self, VALUE window, VALUE renderer)
{
	SDL_Renderer *rend = get_renderer(renderer);
	SDL_Window *win = get_window(window);

	SDL_DestroyWindow(win);
	SDL_DestroyRenderer(rend);
}
