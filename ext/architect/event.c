#include "event.h"

void process(VALUE event_obj)
{
	VALUE event_class = rb_const_get(rb_cObject, rb_intern("Event"));
	rb_funcall(event_class, rb_intern("process"), 1, event_obj);
}

void framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
	// We should also handle the resizing ourselves.
	glViewport(0, 0, width, height);

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, sym("type"), sym("framebuffer_size"));
	rb_hash_aset(hash, sym("window_id"), window_id(window));
	rb_hash_aset(hash, sym("width"), INT2NUM(width));
	rb_hash_aset(hash, sym("height"), INT2NUM(height));

	process(hash);
}

void mouse_position_callback(GLFWwindow *window, double x, double y)
{
	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, sym("type"), sym("mouse_position"));
	rb_hash_aset(hash, sym("window_id"), window_id(window));
	rb_hash_aset(hash, sym("x"), DBL2NUM(x));
	rb_hash_aset(hash, sym("y"), DBL2NUM(y));

	process(hash);
}

void mouse_button_callback(GLFWwindow *window, int button, int action, int mods)
{
	static double last_click_time = 0.0;
	static int click_count = 0;

	double current_time = glfwGetTime();
	double elapsed_time = current_time - last_click_time;

	if (elapsed_time < 0.25)
	{
		click_count++;
	}
	else
	{
		click_count = 1;
	}

	last_click_time = current_time;

	double x, y;
	glfwGetCursorPos(window, &x, &y);

	VALUE hash = rb_hash_new();
	rb_hash_aset(hash, sym("type"), sym("mouse_button"));
	rb_hash_aset(hash, sym("window_id"), window_id(window));
	rb_hash_aset(hash, sym("x"), DBL2NUM(x));
	rb_hash_aset(hash, sym("y"), DBL2NUM(y));
	rb_hash_aset(hash, sym("clicks"), INT2NUM(click_count));

	VALUE rb_action;
	if (action == GLFW_PRESS)
		rb_action = sym("down");
	else
		rb_action = sym("up");

	rb_hash_aset(hash, sym("state"), rb_action);
	rb_hash_aset(hash, sym("button"), INT2NUM(button));

	process(hash);
}
