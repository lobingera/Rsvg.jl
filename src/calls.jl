# collection of calls

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
handle_new_from_data(data::AbstractString) = handle_new_from_data(data::AbstractString,GError(0,0,0))

"""
handle_free(handle::RsvgHandle)
"""
function handle_free(handle::RsvgHandle)
    ccall((:rsvg_handle_free,librsvg), Nothing, (RsvgHandle,), handle)
end
