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

function test_get_dimension(filename_in::AbstractString="d.svg")

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

function test_render_string_to_png(output::AbstractString="b.png",content_string::AbstractString=testd0)
    head = "<svg version=\"1.1\" fill=\"#"
    f1 = "\"><path id=\"2\" d=\""
    f2 = "\"></path> </svg>"
    r = Rsvg.handle_new_from_data(head * "ff00ff" * f1 * content_string * f2);
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,output);
    end

testc0 = """
    c -11.06653,0 -20.16601,9.09944 -20.16601,20.16604 0,11.0665 
    9.09948,20.166 20.16601,20.166 11.06654,0 20.16602,-9.0995 
    20.16602,-20.166 0,-11.0666 -9.09948,-20.16604 -20.16602,-20.16604 
    z m 0,12.00004 c 4.58126,0 8.16602,3.5847 8.16602,8.166 0,4.5812 
    -3.58476,8.166 -8.16602,8.166 -4.58125,0 -8.16601,-3.5848 
    -8.16601,-8.166 0,-4.5813 3.58476,-8.166 8.16601,-8.166 z
    """

function test_render_long_string_to_png(content_length::Int,output::AbstractString="b.png")

    sa = Array{AbstractString}(undef,2+(4*content_length))
    r = rand(content_length,2)

    sa[1] = "<svg version=\"1.1\" fill=\"#" *
    "0088ff\" " *
    "height=\"520\" width=\"520\" " *
    ">" *
    "<g>"

    p = 1 # index into sa, p+=1 is post-increment

    for k=1:content_length
        sa[p+=1] = @sprintf("<path id=\"i%07d\" d=\"",k)
        sa[p+=1] = @sprintf("M %13.6f,%13.6f",20.0 + 460.0*r[k,1],40.0 + 480.0*r[k,2])
        sa[p+=1] = testc0
        sa[p+=1] = "\"/> "
    end
    sa[p+=1] = "</g> </svg>"

    r = Rsvg.handle_new_from_data(join(sa,'\n'));
    cs = Cairo.CairoImageSurface(600,600,Cairo.FORMAT_ARGB32);
    c = Cairo.CairoContext(cs);
    Rsvg.handle_render_cairo(c,r);
    Cairo.write_to_png(cs,output);
    end


function test_roundtrip(filename_in::AbstractString,filename_out::AbstractString)

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
