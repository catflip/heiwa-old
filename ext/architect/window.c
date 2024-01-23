#include "window.h"

void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
	glViewport(0, 0, width, height);
}

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

	// Some things like resize events should automatically be handled here.
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
	glfwMakeContextCurrent(window);

	// Initialize GLAD (if it wasn't initialized already)
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		rb_raise(rb_eStandardError, "[Architect] Failed to initialize GLAD.");
	}

	return Data_Wrap_Struct(rb_cObject, 0, xfree, window);
}

VALUE rb_window_size(VALUE _self, VALUE window)
{
	GLFWwindow *win;
	Data_Get_Struct(window, GLFWwindow, win);

	int width, height;
	glfwGetWindowSize(win, &width, &height);

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, sym("width"), INT2NUM(width));
	rb_hash_aset(hash, sym("height"), INT2NUM(height));

	return hash;
}

VALUE rb_gl_make_context_current(VALUE _self, VALUE window)
{
	GLFWwindow *win;
	Data_Get_Struct(window, GLFWwindow, win);
	glfwMakeContextCurrent(win);

	return Qnil;
}
