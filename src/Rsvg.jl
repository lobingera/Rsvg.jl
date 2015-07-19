#require("Cairo")
#require("Gtk")
#require("Docile")

module Rsvg

include("../deps/deps.jl")
using Cairo
using Gtk
using Docile

include("types.jl")
include("calls.jl")

include("../test/test.jl")

Rsvg.set_default_dpi(72.0) 

end
