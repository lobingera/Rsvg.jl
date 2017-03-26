using BinDeps

@BinDeps.setup

rsvg = library_dependency("rsvg", aliases = ["librsvg", "librsvg-2.2", "librsvg-2-2", "librsvg-2", "librsvg-2.so.2"])

@static if is_linux() begin
        provides(AptGet, "librsvg2-2",rsvg)
    end
end

@static if is_apple() begin
        using Homebrew
        provides(Homebrew.HB, "librsvg", [rsvg], os=:Darwin)
    end
end

@static if is_windows() begin
        using WinRPM
        provides(WinRPM.RPM,"librsvg-2-2",rsvg,os = :Windows)
    end
end

@BinDeps.install Dict(:rsvg => :librsvg)
