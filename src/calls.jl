# collection of calls

"""
handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
"""
function handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
    ccall((:rsvg_handle_get_dimensions,librsvg), Void,
        (RsvgHandle,Ptr{RsvgDimensionData}), handle, &dimension_data)
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
    ccall((:rsvg_set_default_dpi, librsvg), Void,
            (Float64,), dpi)
end
"""
handle_set_dpi(handle::RsvgHandle, dpi::Float64)
"""
function handle_set_dpi(handle::RsvgHandle, dpi::Float64)
    ccall((:rsvg_handle_set_dpi, librsvg), Void,
            (RsvgHandle,Float64), handle, dpi)
end

"""
handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
"""
function handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
	ccall((:rsvg_handle_render_cairo, librsvg), Bool,
        (RsvgHandle,Ptr{Void}), handle, cr.ptr)
end

"""
handle_new_from_file(filename::AbstractString,error::GError)
"""
function handle_new_from_file(filename::AbstractString,error::GError)
    ptr = ccall((:rsvg_handle_new_from_file, librsvg), Ptr{Void},
                (Cstring,GError), bytestring(filename), error)
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
    ptr = ccall((:rsvg_handle_new_from_data, librsvg), Ptr{Void},
                (Ptr{UInt8},UInt32,GError), bytestring(data), sizeof(data),error)
    RsvgHandle(ptr)
end

"""
handle_new_from_data(data::AbstractString)
"""
handle_new_from_data(data::AbstractString) = handle_new_from_data(data::AbstractString,GError(0,0,0))
