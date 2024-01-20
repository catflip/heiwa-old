#include "render.h"

VALUE rb_gl_viewport(VALUE _self, VALUE options)
{
	int x = NUM2INT(rb_hash_aref(options, sym("x")));
	int y = NUM2INT(rb_hash_aref(options, sym("y")));
	int width = NUM2INT(rb_hash_aref(options, sym("width")));
	int height = NUM2INT(rb_hash_aref(options, sym("height")));
	glViewport(x, y, width, height);

	return Qnil;
}

VALUE rb_gl_swap_buffers(VALUE _self, VALUE window)
{
	GLFWwindow *win;
	Data_Get_Struct(window, GLFWwindow, win);
	glfwSwapBuffers(win);

	return Qnil;
}

VALUE rb_gl_poll_events(VALUE _self)
{
	glfwPollEvents();

	return Qnil;
}

VALUE rb_gl_clear_color(VALUE _self, VALUE color)
{
	float r = (float)NUM2DBL(rb_ary_entry(color, 0));
	float g = (float)NUM2DBL(rb_ary_entry(color, 1));
	float b = (float)NUM2DBL(rb_ary_entry(color, 2));
	float a = (float)NUM2DBL(rb_ary_entry(color, 3));

	glClearColor(r, g, b, a);

	return Qnil;
}

VALUE rb_gl_clear(VALUE _self, VALUE mask_sym)
{
	GLbitfield mask;
	if (mask_sym == sym("color_buffer_bit"))
	{
		mask = GL_COLOR_BUFFER_BIT;
	}

	glClear(GL_COLOR_BUFFER_BIT);

	return Qnil;
}
