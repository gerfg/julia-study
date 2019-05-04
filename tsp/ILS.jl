module ILS

include("./DataMD.jl")
include("./SolutionMD.jl")
using .DataMD
using .SolutionMD

export run

function run(data)
    iterILS = 50
    maxIterILS = 0;

    if data.dimension < 150
        maxIterILS = data.dimension
    else
        maxIterILS = data.dimension/2
    end

    # for iter in 1:iterILS
        cl = 1:data.dimension
        println(typeof(cl))
    # end

end

function cheaper_insertion()

end

end