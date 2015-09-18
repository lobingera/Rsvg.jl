function handle_get_dimensions(handle::RsvgHandle, dimension_data::RsvgDimensionData)
    ccall((:rsvg_handle_get_dimensions, _jl_librsvg), Void,
                (RsvgHandle,Ptr{RsvgDimensionData}), handle, &dimension_data)
end

function set_default_dpi(dpi::Float64)
    ccall((:rsvg_set_default_dpi, _jl_librsvg), Void,
                (Float64,), dpi)
end

function handle_set_dpi(handle::RsvgHandle, dpi::Float64)
    ccall((:rsvg_handle_set_dpi, _jl_librsvg), Void,
                (RsvgHandle,Float64), handle, dpi)
end

function handle_render_cairo(cr::CairoContext, handle::RsvgHandle)
	ccall((:rsvg_handle_render_cairo, _jl_librsvg), Bool,
                (RsvgHandle,Ptr{Void}), handle, cr.ptr)
end

function handle_new_from_file(filename::String,error::GError)
    ptr = ccall((:rsvg_handle_new_from_file, _jl_librsvg), Ptr{Void},
                (Ptr{Uint8},GError), bytestring(filename), error)
    RsvgHandle(ptr)
end

handle_new_from_file(filename::String) = handle_new_from_file(filename::String,GError(0,0,0))

function handle_new_from_data(data::String,error::GError)
    ptr = ccall((:rsvg_handle_new_from_data, _jl_librsvg), Ptr{Void},
                (Ptr{Uint8},Uint32,GError), bytestring(data), length(data),error)
    RsvgHandle(ptr)
end

handle_new_from_data(data::String) = handle_new_from_data(data::String,GError(0,0,0))
