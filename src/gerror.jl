struct GError
    domain::UInt32
    code::Cint
    message::Ptr{UInt8}
end
