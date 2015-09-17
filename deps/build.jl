using BinDeps

@BinDeps.setup

#deps = [
	rsvg = library_dependency("rsvg", aliases = ["librsvg"])
#]
@BinDeps.install [:rsvg => :_jl_librsvg ]


