module ILS

include("./DataMD.jl")
include("./SolutionMD.jl")
using .DataMD
using .SolutionMD

export run

function run(data)
    iter_ils = 50
    maxIter_ils = 0;

    if data.dimension < 150
        max_iter_ils = data.dimension
    else
        max_iter_ils = data.dimension/2
    end

    # for iter in 1:iterils
        candidate_list = 1:data.dimension
        println(typeof(candidate_list), "\n" ,candidate_list)
        println(candidate_list[5])
        filter!(x->x≠5, candidate_list)
        println(typeof(candidate_list), "\n" ,candidate_list)
    # end

end

function cheaper_insertion()

end

end