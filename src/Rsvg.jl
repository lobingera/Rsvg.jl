module Rsvg

using Cairo
using Glib_jll
using Librsvg_jll

include("gerror.jl")
include("gio.jl")
include("types.jl")
include("calls.jl")

export RsvgDimensionData, RsvgHandle


function __init__()
	Rsvg.set_default_dpi(72.0)
end

end # module






