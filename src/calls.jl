# collection of calls

# /**
#  * rsvg_handle_new_from_stream_sync:
#  * @input_stream: a #GInputStream
#  * @base_file: (allow-none): a #GFile, or %NULL
#  * @flags: flags from #RsvgHandleFlags
#  * @cancellable: (allow-none): a #GCancellable, or %NULL
#  * @error: (allow-none): a location to store a #GError, or %NULL
#  *
#  * Creates a new #RsvgHandle for @stream.
#  *
#  * If @cancellable is not %NULL, then the operation can be cancelled by
#  * triggering the cancellable object from another thread. If the
#  * operation was cancelled, the error %G_IO_ERROR_CANCELLED will be
#  * returned.
#  *
#  * Returns: a new #RsvgHandle on success, or %NULL with @error filled in
#  *
#  * Since: 2.32
#  */
# RsvgHandle *
# rsvg_handle_new_from_stream_sync (GInputStream   *input_stream,
#                                   GFile          *base_file,
#                                   RsvgHandleFlags flags,
#                                   GCancellable    *cancellable,
#                                   GError         **error)
# {


"""
handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
"""
function handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
    ccall((:rsvg_handle_get_dimensions,librsvg), Nothing,
        (RsvgHandle,Ptr{RsvgDimensionData}), handle, Ref(dimension_data))
end

"""
dimension_data = handle_get_dimensions(handle::RsvgHandle)
"""
function handle_get_dimensions(handle::RsvgHandle)
    d = Rsvg.RsvgDimensionData(1,1,1,1);
    handle_get_dimensions(handle, d);
    d
end

"""
set_default_dpi(dpi::Float64)
"""
function set_default_dpi(dpi::Float64)
    ccall((:rsvg_set_default_dpi, librsvg), Nothing,
            (Float64,), dpi)
end
"""
handle_set_dpi(handle::RsvgHandle, dpi::Float64)
"""
function handle_set_dpi(handle::RsvgHandle, dpi::Float64)
    ccall((:rsvg_handle_set_dpi, librsvg), Nothing,
            (RsvgHandle,Float64), handle, dpi)
end

"""
handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
"""
function handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
	ccall((:rsvg_handle_render_cairo, librsvg), Bool,
        (RsvgHandle,Ptr{Nothing}), handle, cr.ptr)
end

"""
handle_new_from_file(filename::AbstractString,error::GError)
"""
function handle_new_from_file(filename::AbstractString,error::GError)
    ptr = ccall((:rsvg_handle_new_from_file, librsvg), Ptr{Nothing},
                (Cstring,GError), string(filename), error)
    RsvgHandle(ptr)
end

"""
handle_new_from_file(filename::AbstractString)
"""
handle_new_from_file(filename::AbstractString) = handle_new_from_file(filename::AbstractString,GError(0,0,0))

"""
handle_new_from_data(data::AbstractString,error::GError)
"""
function handle_new_from_data(data::AbstractString,error::GError)
    ptr = ccall((:rsvg_handle_new_from_data, librsvg), Ptr{Nothing},
                (Ptr{UInt8},UInt32,GError), string(data), sizeof(data),error)
    RsvgHandle(ptr)
end

"""
handle_new_from_data(data::AbstractString)
"""
function handle_new_from_data(data::AbstractString)

    perr = Ref{Ptr{GError}}(C_NULL)

    g_input_stream = Rsvg.glib_memory_input_stream_new_from_data(data)

    ptr = ccall((:rsvg_handle_new_from_stream_sync, librsvg), Ptr{Nothing},
        (GInputStream,Ptr{Nothing},UInt32,Ptr{Nothing},Ptr{Ptr{GError}}), 
        g_input_stream,C_NULL,0,C_NULL,perr)


    if ptr == C_NULL
        err = unsafe_load(perr[])
        message = unsafe_string(err.message)
        ccall((:g_error_free, librsvg), Cvoid, (Ptr{GError},), perr[])
        error(message)
    end

    RsvgHandle(ptr)
end


"""
handle_free(handle::RsvgHandle)
"""
function handle_free(handle::RsvgHandle)
    ccall((:rsvg_handle_free,librsvg), Nothing, (RsvgHandle,), handle)
end

"""
handle_free(handle::GInputStream)
"""
function handle_free(handle::GInputStream)
    ccall((:g_input_stream_close,libgio), Nothing, 
        (GInputStream,Ptr{Nothing},Ptr{Nothing}), handle,C_NULL,C_NULL)
end
