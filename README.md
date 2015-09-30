Rsvg.jl
=======

Adaptation of the [librsvg](https://wiki.gnome.org/LibRsvg?action=show]).

This is a subset of the full API, but the main points

* Open an svg file and render to a Cairo Context (surface)
* Read svg data from a string and render to a Cairo Context

are available.

(To be correct at this point: A full binding/adaptation should be done via GObject Introspection - which might be available in the future. This here is just ccalls to solve svg to cairo import problems...)

Usage
=====
```
using Rsvg
using Cairo

filename_in = "a4.svg"
filename_out = "a4.png"

r = Rsvg.handle_new_from_file(filename_in);
d = Rsvg.handle_get_dimensions(r);
cs = Cairo.CairoImageSurface(d.width,d.height,Cairo.FORMAT_ARGB32);
c = Cairo.CairoContext(cs);
Rsvg.handle_render_cairo(c,r);
Cairo.write_to_png(cs,filename_out);
```
