using BinDeps
using Compat

@BinDeps.setup

rsvg = library_dependency("rsvg", aliases = ["librsvg", "librsvg-2.2", "librsvg-2-2", "librsvg-2", "librsvg-2.so.2"])

@static if Sys.islinux() begin
        provides(AptGet, "librsvg2-2",rsvg)
    end
end

@static if Sys.isapple() begin
        using Homebrew
        provides(Homebrew.HB, "librsvg", [rsvg], os=:Darwin)
    end
end

@static if Sys.iswindows() begin
        using WinRPM
        provides(WinRPM.RPM,"librsvg-2-2",rsvg,os = :Windows)
    end
end

@BinDeps.install Dict(:rsvg => :librsvg)
