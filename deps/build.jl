using BinDeps

@BinDeps.setup

rsvg = library_dependency("rsvg", aliases = ["librsvg", "librsvg-2.2", "librsvg-2", "librsvg-2.so.2"])

@linux_only begin
    provides(AptGet, "librsvg2-2",rsvg)
end

@osx_only begin
    using Homebrew
    provides(Homebrew.HB, "librsvg", [rsvg], os=:Darwin)
end

@BinDeps.install Dict(:rsvg => :librsvg)
