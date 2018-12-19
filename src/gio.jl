# g_memory_input_stream_new_from_data ()
# GInputStream *
# g_memory_input_stream_new_from_data (const void *data,
#                                      gssize len,
#                                      GDestroyNotify destroy);
# Creates a new GMemoryInputStream with data in memory of a given size.
# Parameters
# data
# input data.
# 	[array length=len][element-type guint8][transfer full]
# len
# length of the data, may be -1 if data is a nul-terminated string
# destroy
# function that is called to free data , or NULL.
# 	[nullable]
# Returns
# new GInputStream read from data of len bytes.

mutable struct GInputStream
	ptr::Ptr{Nothing}
	    
    function GInputStream(ptr::Ptr{Nothing})
        self = new(ptr)
        @compat finalizer(destroy, self)
        self
    end
end

function destroy(handle::GInputStream)
    if handle.ptr == C_NULL
        return
    end
    handle_free(handle)
    handle.ptr = C_NULL
    nothing
end


function glib_memory_input_stream_new_from_data(data::AbstractString)
	    ptr = ccall((:g_memory_input_stream_new_from_data, libgio), Ptr{Nothing},
                (Ptr{UInt8},UInt32,Ptr{Nothing}), string(data), sizeof(data),C_NULL)
    	GInputStream(ptr)
end