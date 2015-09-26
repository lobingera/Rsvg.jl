using BinDeps

@BinDeps.setup

rsvg = library_dependency("rsvg", aliases = ["librsvg","librsvg-2.so.2"])

@linux_only begin
    provides(AptGet, "librsvg2-2",rsvg)
end

@BinDeps.install Dict(:rsvg => :librsvg)




