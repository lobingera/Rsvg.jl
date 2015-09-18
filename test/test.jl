function test_render_to_png(filename_in::AbstractString="draw1.svg",
    filename_out::AbstractString="b.png")

    # file should be available
    if Base.stat(filename_in).size == 0
         error(@sprintf("%s : file not found",filename_in));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename_in);
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,filename_out);
end

function test_get_dimension(filename_in::String="d.svg")

    # file should be available
    if Base.stat(filename_in).size == 0
         error(@sprintf("%s : file not found",filename_in));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename_in);
    d = Rsvg.RsvgDimensionData(1,1,1,1);

    Rsvg.handle_get_dimensions(r,d);
    d
end

# test data, icon of a light bulb, path data only
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

function test_render_string_to_png(output::String="b.png",content_string::String=testd0)
    head = "<svg version=\"1.1\" fill=\"#"
    f1 = "\"><path id=\"2\" d=\""
    f2 = "\"></path> </svg>"
    r = Rsvg.handle_new_from_data(head * "ff00ff" * f1 * content_string * f2);
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,output);
    end

function test_roundtrip(filename_in::String,filename_out::String)

    # file should be available
    if Base.stat(filename_in).size == 0
         error(@sprintf("%s : file not found",filename_in));
         nothing
    end

    r = Rsvg.handle_new_from_file(filename_in);
    d = RsvgDimensionData(1,1,1,1);
    Rsvg.handle_get_dimensions(r,d);

    #d0 = split(filename_in,".")
    #filename_out = d0[1] * "_rt." * d0[2]

   # @printf("input file %s, output file %s\n",filename_in,filename_out)

    cs = Cairo.CairoSVGSurface(filename_out,d.width,d.height);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.finish(cs);

    nothing
    end
