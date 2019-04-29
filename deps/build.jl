using BinDeps

@BinDeps.setup


rsvg = library_dependency("rsvg", aliases = ["librsvg", "librsvg-2.2", "librsvg-2-2", "librsvg-2", "librsvg-2.so.2"])
gio = library_dependency("gio", aliases = ["libgio-2.0", "libgio-2.0-0"])



@static if Sys.islinux() begin
        provides(AptGet, "librsvg2-2", rsvg)
        provides(AptGet, "libgio", gio)
    end
end

@static if Sys.isapple() begin
        using Homebrew
        provides(Homebrew.HB, "librsvg", [rsvg], os=:Darwin)
        provides(Homebrew.HB, "libgio", [gio], os=:Darwin)
    end
end

@static if Sys.iswindows() begin
        using WinRPM
        provides(WinRPM.RPM,"librsvg-2-2",rsvg,os = :Windows)
        provides(WinRPM.RPM,"glib2",gio,os = :Windows)
    end
end

@BinDeps.install Dict([
	(:rsvg => :librsvg),
    (:gio, :libgio),
])
