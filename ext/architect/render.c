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

VALUE rb_gl_bind_vertex_array(VALUE _self, VALUE vao_obj)
{
	GLuint VAO;
	if (RB_TYPE_P(vao_obj, T_FIXNUM))
	{
		VAO = NUM2INT(vao_obj);
	}
	else
	{
		Data_Get_Struct(vao_obj, GLuint, VAO);
	}
	glBindVertexArray(VAO);

	return Qnil;
}

VALUE rb_gl_draw_arrays(VALUE _self, VALUE mode_sym, VALUE first, VALUE count)
{
	GLenum mode;
	if (mode_sym == sym("points"))
	{
		mode = GL_POINTS;
	}
	else
	{
		mode = GL_TRIANGLES;
	}

	glDrawArrays(mode, (GLsizei)NUM2INT(first), (GLenum)NUM2INT(count));

	return Qnil;
}

VALUE rb_gl_draw_elements(VALUE _self, VALUE mode_sym, VALUE count, VALUE type_sym, VALUE indices_obj)
{
	const void *indices = 0;
	if (!RB_TYPE_P(indices_obj, T_NIL))
	{
		Data_Get_Struct(indices_obj, const void *, indices);
	}

	GLenum mode;
	if (mode_sym == sym("points"))
	{
		mode = GL_POINTS;
	}
	else
	{
		mode = GL_TRIANGLES;
	}

	GLenum type;
	if (type_sym == sym("unsigned_int"))
	{
		type = GL_UNSIGNED_INT;
	}

	glDrawElements(mode, NUM2INT(count), type, indices);

	return Qnil;
}
