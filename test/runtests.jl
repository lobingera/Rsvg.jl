using Rsvg
using Cairo
using Gtk

using Base.Test

include("test.jl")

pkg_dir = Pkg.dir("Rsvg")

@printf("\nTest: dimension of known images")

d = test_get_dimension(joinpath(pkg_dir,"data","mulberry.svg"));
@test (d.height == 512) & (d.width == 513)

d = test_get_dimension(joinpath(pkg_dir,"data","diag.svg"));
@test (d.height == 400) & (d.width == 400)

d = test_get_dimension(joinpath(pkg_dir,"data","lotus.svg"));
@test (d.height == 720) & (d.width == 576)

d = test_get_dimension(joinpath(pkg_dir,"data","star.svg"));
@test (d.height == 198) & (d.width == 224)

@printf("\nTest: render to png")

f = tempname() * ".png"
test_render_to_png(joinpath(pkg_dir,"data","mulberry.svg"),f);
@test stat(f).size > 0

f = tempname() * ".png"
test_render_to_png(joinpath(pkg_dir,"data","diag.svg"),f);
@test stat(f).size > 0

f = tempname() * ".png"
test_render_to_png(joinpath(pkg_dir,"data","lotus.svg"),f);
@test stat(f).size > 0

f = tempname() * ".png"
test_render_to_png(joinpath(pkg_dir,"data","star.svg"),f);
@test stat(f).size > 0



@printf("\n");