using Rsvg
using Compat
using Cairo
using Compat.Printf


using Compat.Test

include("test.jl")

pkg_dir = dirname(dirname(@__FILE__))


@testset "dimensions of known images  " begin

d = test_get_dimension(joinpath(pkg_dir,"data","mulberry.svg"));

@test d.height == 512
@test d.width == 513

d = test_get_dimension(joinpath(pkg_dir,"data","diag.svg"));

@test d.height == 400
@test d.width == 400

d = test_get_dimension(joinpath(pkg_dir,"data","lotus.svg"));

@test d.height == 720
@test d.width == 576

d = test_get_dimension(joinpath(pkg_dir,"data","star.svg"));

@test d.height == 198
@test d.width == 224

end


@testset "render to png               " begin

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

end


@testset "render string to png        " begin

f = tempname() * ".png"
test_render_string_to_png(f);
@test stat(f).size > 0

f = tempname() * ".png"
test_render_long_string_to_png(3000,f);
@test stat(f).size > 0

f = tempname() * ".png"
test_render_long_string_to_png(60000,f);
@test stat(f).size > 0

end

@testset "roundtrip, render svg to svg" begin

f = tempname() * ".svg"
test_roundtrip(joinpath(pkg_dir,"data","lotus.svg"),f);

@test stat(f).size > 0

d = test_get_dimension(f);
@test d.height == 720
@test d.width == 576

end
