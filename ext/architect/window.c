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

	// Set user pointers
	glfwSetWindowUserPointer(window, window);
	glfwMakeContextCurrent(window);

	// Initialize GLAD (if it wasn't initialized already)
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		rb_raise(rb_eStandardError, "[Architect] Failed to initialize GLAD.");
	}

	VALUE rb_window_id = ULL2NUM((unsigned long long)window);
	VALUE rb_window = Data_Wrap_Struct(rb_cObject, 0, xfree, window);

	// Return the ID and the window itself.
	VALUE array = rb_ary_new();
	rb_ary_push(array, rb_window_id);
	rb_ary_push(array, rb_window);

	return array;
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
