module RVND

include("./neighborhood_structures/swap.jl")

export run

neighborhood_structures = Dict(
    ":swap" => (data, solution)->swap(data, solution)
)

function run(data, solution)
    neighb_list = neighb_list_reset()

    
    while length(neighb_list) > 0
        neighb = neighb_list_get_random(neighb_list)
        println(neighb)
        neighborhood_structures[neighb](data, solution)
        neighb_list_remove!(neighb, neighb_list)
    end
    println("end rvnd.")
end

function neighb_list_reset()
    return Array([":swap"])
end

function neighb_list_get_random(list)
    position = rand(1:length(list))
    return list[position]
end

function neighb_list_remove!(neighb, list)
    filter!(x -> x ≠ neighb, list)
end

end