#include "screen.h"

ScreenSize *screen_size(GLFWmonitor *monitor)
{
    GLFWvidmode *mode = glfwGetVideoMode(monitor);

    if (mode == NULL)
    {
        rb_raise(rb_eStandardError, "[Architect] Failed to get video mode from monitor!");
        return NULL;
    }

    ScreenSize *size = (ScreenSize *)malloc(sizeof(ScreenSize));
    size->width = mode->width;
    size->height = mode->height;

    return size;
}

VALUE rb_screen_size(VALUE _self, VALUE monitor)
{
    GLFWmonitor *mon;
    Data_Get_Struct(monitor, GLFWmonitor, mon);

    ScreenSize *size = screen_size(mon);
    VALUE hash = rb_hash_new();
    rb_hash_aset(hash, sym("width"), INT2NUM(size->width));
    rb_hash_aset(hash, sym("height"), INT2NUM(size->height));

    free(size);

    return hash;
}

VALUE rb_gl_primary_monitor(VALUE _self)
{
    const GLFWmonitor *monitor = glfwGetPrimaryMonitor();
	return Data_Wrap_Struct(rb_cObject, 0, xfree, monitor);
}
