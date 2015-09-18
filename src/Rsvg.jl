
module Rsvg

include("../deps/deps.jl")

using Cairo
using Gtk

include("types.jl")
include("calls.jl")

export RsvgDimensionData, RsvgHandle

Rsvg.set_default_dpi(72.0) 

end # module                                            





