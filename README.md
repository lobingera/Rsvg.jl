Rsvg.jl
=======

[![Build Status](https://travis-ci.org/lobingera/Rsvg.jl.svg?branch=master)](https://travis-ci.org/lobingera/Rsvg.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/up2sxjlgb0hl75vl/branch/master?svg=true)](https://ci.appveyor.com/project/lobingera/rsvg-jl/branch/master)
[![Rsvg](http://pkg.julialang.org/badges/Rsvg_0.6.svg)](http://pkg.julialang.org/?pkg=Rsvg)

Adaptation of the [librsvg](https://wiki.gnome.org/LibRsvg?action=show).

This is a subset of the full API, but the main points

* Open an svg file and render to a Cairo Context (surface)
* Read svg data from a string and render to a Cairo Context

are available.

(To be correct at this point: A full binding/adaptation should be done via GObject Introspection - which might be available in the future. This here is just ccalls to solve sv to cairo import problems...)

Note on API: nothing is exported, you need to prefix Rsvg.callsomething

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
API
===
```
handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
dimension_data = handle_get_dimensions(handle::RsvgHandle)
set_default_dpi(dpi::Float64)
handle_set_dpi(handle::RsvgHandle, dpi::Float64)
handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
handle_new_from_file(filename::AbstractString,error::GError)
handle_new_from_file(filename::AbstractString)
handle_new_from_data(data::AbstractString,error::GError)
handle_new_from_data(data::AbstractString)
```

Some Notes on Error Handling
============================
There is none. You'll get all kinds of errors (missing something) via the GLib internals. 

Interaction with other GLib based libraries
===========================================
librsvg is usually used in a Gnome/GLib context. Some of the features therefore depend on availability of a GLib as shared resource, especially memory management. This package e.g. depends for destroying RsvgHandles on GLib infrastructure and strange things can happen if you manage to load 2 different GLib instances. As long as you use Rsvg along Gtk.jl and Cairo.jl you should be fine.

