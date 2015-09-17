function test_render_to_png(filename::String="draw1.svg",output::String="b.png")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename,Rsvg.GError(0,0,0));
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,output);
end

function test_get_dimension(filename::String="d.svg")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename,Rsvg.GError(0,0,0));
    d = RsvgDimensionData(1,1,1,1);

    Rsvg.handle_get_dimensions(r,d);
    d
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
function test_render_string_to_png(output::String="b.png")
    #using Rsvg
    head = "<svg version=\"1.1\" fill=\"#"
    f1 = "\"><path id=\"2\" d=\""
    f2 = "\"></path> </svg>"
    d = Rsvg.testd0
    r = Rsvg.handle_new_from_data(head * "ff00ff" * f1 * d * f2,Rsvg.GError(0,0,0));
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,output);
    end

@doc """
test4: run a (named) file through Rsvg and output a .svg (via Cairo)
""" ->
function test_roundtrip(filename::String="d.svg")

    # file should be available
    if Base.stat(filename).size == 0
         error(@sprintf("%s : file not found",filename));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename,Rsvg.GError(0,0,0));
    d = RsvgDimensionData(1,1,1,1);
    Rsvg.handle_get_dimensions(r,d);

    d0 = split(filename,".")
    d1 = d0[1] * "_rt." * d0[2]
    cs = Cairo.CairoSVGSurface(d1,d.width,d.height);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.finish(cs);

    #c,cs,d
    nothing
    end
