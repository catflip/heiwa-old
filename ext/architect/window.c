#include "window.h"

VALUE rb_create_window(VALUE self, VALUE options)
{
	int width = NUM2INT(rb_hash_aref(options, sym("width")));
	int height = NUM2INT(rb_hash_aref(options, sym("height")));
	VALUE rb_title = rb_hash_aref(options, sym("title"));
	const char *title = StringValueCStr(rb_title);

	GLFWwindow *window = glfwCreateWindow(width, height, title, NULL, NULL);

	if (window == NULL)
	{
		rb_raise(rb_eStandardError, "[Architect] Failed to create the window.");
		glfwTerminate();
		return Qnil;
	}

	// Initialize GLAD (if it wasn't initialized already)
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		rb_raise(rb_eStandardError, "[Architect] Failed to initialize GLAD.");
	}

	return Data_Wrap_Struct(rb_cObject, 0, xfree, window);
}
