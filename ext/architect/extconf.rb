require 'mkmf'

have_header 'ruby.h' or missing 'ruby.h'

# Compile with SDL2
$LDFLAGS << ' -lSDL2 -lSDL2_gfx -lSDL2_ttf'

create_makefile 'heiwa/architect'
