#include "util.h"

VALUE sym(const char *symbol)
{
	return ID2SYM(rb_intern(symbol));
}
