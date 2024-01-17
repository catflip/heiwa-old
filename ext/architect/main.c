#include <stdio.h>
#include <ruby.h>

VALUE info()
{
	return rb_str_new_cstr("Pong!");
}

VALUE init_glfw()
{
	return Qnil;
}

void Init_architect()
{
	VALUE architect = rb_define_module("Architect");

	rb_define_module_function(architect, "ping", info, 0);
	rb_define_module_function(architect, "gl_init", init_glfw, 0);
}
