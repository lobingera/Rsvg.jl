
"""
RsvgHandle is a container for the actual GLib pointer to datastructure
"""
mutable struct RsvgHandle 
	ptr::Ptr{Nothing}
	    
    function RsvgHandle(ptr::Ptr{Nothing})
        self = new(ptr)
        @compat finalizer(destroy, self)
        self
    end
end

function destroy(handle::RsvgHandle)
    if handle.ptr == C_NULL
        return
    end
    handle_free(handle)
    handle.ptr = C_NULL
    nothing
end

"""
RsvgDimensionData is a simple struct of 
    width::Int32
    height::Int32
    em::Float64
    ex::Float64
"""
mutable struct RsvgDimensionData
    width::Int32
    height::Int32
    em::Float64
    ex::Float64
end

RsvgDimensionData() = RsvgDimensionData(0,0,0,0)