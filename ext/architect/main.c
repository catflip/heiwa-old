#include "glad.h"

#include <stdio.h>
#include <ruby.h>
#include <GLFW/glfw3.h>

#include "window.h"
#include "screen.h"

VALUE info()
{
	return rb_str_new_cstr("Pong!");
}

VALUE init_glfw()
{
	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	return Qnil;
}

void Init_architect()
{
	VALUE architect = rb_define_module("Architect");

	rb_define_module_function(architect, "ping", info, 0);

	// GL/GLFW Methods
	rb_define_module_function(architect, "gl_init", init_glfw, 0);
	rb_define_module_function(architect, "gl_primary_monitor", rb_gl_primary_monitor, 0);
	rb_define_module_function(architect, "gl_make_context", rb_gl_make_context_current, 1);

	// Common Methods
	rb_define_module_function(architect, "create_window", rb_create_window, 1);

	VALUE screen = rb_define_module("Screen");

	rb_define_module_function(screen, "screen_size", rb_screen_size, 1);
}
