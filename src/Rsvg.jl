require("Cairo")
require("Gtk")
require("Docile")

module Rsvg

include("../deps/deps.jl")
using Cairo
using Gtk
using Docile

@docstrings

type RsvgHandle 
	ptr::Ptr{Void}
	    
    function RsvgHandle(ptr::Ptr{Void})
        self = new(ptr)
        finalizer(self, destroy)
        self
    end
end

function destroy(handle::RsvgHandle)
    if handle.ptr == C_NULL
        return
    end
    Gtk.GLib.gc_unref(handle)
    handle.ptr = C_NULL
    nothing
end

GError = Gtk.GLib.GError

type RsvgDimensionData
    width::Int32
    height::Int32
    em::Float64
    ex::Float64
end

RsvgDimensionData() = RsvgDimensionData(0,0,0,0)

function rsvg_handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
    ccall((:rsvg_handle_get_dimensions, _jl_librsvg), Void,
                (RsvgHandle,Ptr{RsvgDimensionData}), handle, &dimension_data)
end

# rsvg_handle_set_dpi ()

# void
# rsvg_handle_set_dpi (RsvgHandle *handle,
#                      double dpi);

function rsvg_set_default_dpi(dpi::Float64)
    ccall((:rsvg_set_default_dpi, _jl_librsvg), Void,
                (Float64,), dpi)
end


function rsvg_handle_set_dpi(handle::RsvgHandle, dpi::Float64)
    ccall((:rsvg_handle_set_dpi, _jl_librsvg), Void,
                (RsvgHandle,Float64), handle, dpi)
end

function rsvg_handle_render_cairo (cr::CairoContext, handle::RsvgHandle)
	ccall((:rsvg_handle_render_cairo, _jl_librsvg), Bool,
                (RsvgHandle,Ptr{Void}), handle, cr.ptr)
end

function rsvg_handle_new_from_file (filename::String,error::GError)
    ptr = ccall((:rsvg_handle_new_from_file, _jl_librsvg), Ptr{Void},
                (Ptr{Uint8},GError), bytestring(filename), error)
    RsvgHandle(ptr)
end

function rsvg_handle_new_from_data (data::String,error::GError)
    ptr = ccall((:rsvg_handle_new_from_data, _jl_librsvg), Ptr{Void},
                (Ptr{Uint8},Uint32,GError), bytestring(data), length(data),error)
    RsvgHandle(ptr)
end

Rsvg.rsvg_set_default_dpi(72.0) 

function test1(filename::String="draw1.svg")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end

    r = Rsvg.rsvg_handle_new_from_file(filename,Rsvg.GError(0,0,0));
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.rsvg_handle_render_cairo(c,r);
    Cairo.write_to_png(cs,"b.png");
end

function test3(filename::String="d.svg")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end

    r = Rsvg.rsvg_handle_new_from_file(filename,Rsvg.GError(0,0,0));
    d = RsvgDimensionData(1,1,1,1);

    Rsvg.rsvg_handle_get_dimensions(r,d);
    d
    # cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    # c = Cairo.CairoContext(cs);
    # Rsvg.rsvg_handle_render_cairo(c,r);
    # Cairo.write_to_png(cs,"b.png");
end

testd0 = """
    M299.823,364.41h-87.646c-6.144,0-11.124,4.979-11.124,11.123c
    0,6.143,4.98,11.122,11.124,11.122h87.647c6.143,0,11.123-4.979,11.123-11.122C
    310.947,369.39,305.967,364.41,299.823,364.41z M297.822,401.443h
    -83.645c-6.143,0-11.123,4.98-11.123,11.123s
    4.98,11.122,11.123,11.122h83.646c6.142,0,11.122-4.979,11.122-11.122S
    303.965,401.443,297.822,401.443z M214.75,437.961C
    236.406,457.979,238.636,462,247.28,462h16.65c8.45,0,10.532-3.727,33.319-24.039H
    214.75z M382.621,171.454c0,75.31-64.767,117.514-64.767,176.943h
    -29.493c0.025-73.246,64.232-111.827,64.232-176.943c
    0-121.891-193.188-122.082-193.188,0c0,65.057,63.094,101.976,64.558,176.943h
    -29.818c0-59.43-64.767-101.634-64.767-176.943C
    129.379,9.598,382.621,9.433,382.621,171.454z
    """    

testd1 = """
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="400pt" height="400pt" viewBox="0 0 400 400" version="1.1">
<g id="surface1">
<path style="fill:none;stroke-width:2;stroke-linecap:butt;stroke-linejoin:miter;stroke:rgb(0%,0%,0%);stroke-opacity:1;stroke-miterlimit:10;" d="M 20 20 L 380 380 "/>
</g>
</svg>
"""


@doc """
test2() runs a predefinded string to rsvg_handle_new_from_data 
""" ->

function test2()
    #using Rsvg
    head = "<svg version=\"1.1\" fill=\"#"
    f1 = "\"><path id=\"2\" d=\""
    f2 = "\"></path> </svg>"
    d = Rsvg.testd0
    r = Rsvg.rsvg_handle_new_from_data(head * "ff00ff" * f1 * d * f2,Rsvg.GError(0,0,0));
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.rsvg_handle_render_cairo(c,r);
    Cairo.write_to_png(cs,"b.png");
    end

function test4(filename::String="d.svg")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end



    r = Rsvg.rsvg_handle_new_from_file(filename,Rsvg.GError(0,0,0));
    d = RsvgDimensionData(1,1,1,1);
    Rsvg.rsvg_handle_get_dimensions(r,d);

    #Rsvg.rsvg_set_dpi(0.0)
    # 
    d0 = split(filename,".")
    d1 = d0[1] * "_rt." * d0[2]
    cs = Cairo.CairoSVGSurface(d1,d.width,d.height);
    c = Cairo.CairoContext(cs);
    Rsvg.rsvg_handle_render_cairo(c,r);
    Cairo.finish(cs);

    c,cs,d
    
    end
             
end                                             