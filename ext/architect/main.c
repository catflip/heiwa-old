#include <stdio.h>
#include <ruby.h>
#include <GLFW/glfw3.h>

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
	rb_define_module_function(architect, "gl_init", init_glfw, 0);
}
