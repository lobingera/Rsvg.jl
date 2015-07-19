type RsvgHandle 
	ptr::Ptr{Void}
	    
    function RsvgHandle(ptr::Ptr{Void})
        self = new(ptr)
        finalizer(self, destroy)
        self
    end
end

function destroy(handle::RsvgHandle)
    if handle.ptr == C_NULL
        return
    end
    Gtk.GLib.gc_unref(handle)
    handle.ptr = C_NULL
    nothing
end

GError = Gtk.GLib.GError

type RsvgDimensionData
    width::Int32
    height::Int32
    em::Float64
    ex::Float64
end

RsvgDimensionData() = RsvgDimensionData(0,0,0,0)