#include "util.h"

VALUE sym(const char *symbol)
{
	return ID2SYM(rb_intern(symbol));
}

VALUE window_id(GLFWwindow *window)
{
	return ULL2NUM((unsigned long long)glfwGetWindowUserPointer(window));
}
