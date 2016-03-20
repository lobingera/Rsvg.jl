
module Rsvg

depsjl = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
isfile(depsjl) ? include(depsjl) : error("Rsvg not properly ",
    "installed. Please run\nPkg.build(\"Rsvg\")")

using Cairo
using Gtk

include("types.jl")
include("calls.jl")

export RsvgDimensionData, RsvgHandle

Rsvg.set_default_dpi(72.0) 

end # module                                            






