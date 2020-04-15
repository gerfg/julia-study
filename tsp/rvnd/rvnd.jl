module RVND

include("./neighborhood_structures/swap.jl")

export run

neighborhood_structures = Dict(
    ":swap" => (data, solution)->swap(data, solution)
)

function run(data, solution)
    neighb_list = neighb_list_reset()

    new_array_rvnd(solution.customers)

    return

    while length(neighb_list) > 0
        neighb = neighb_list_get_random(neighb_list)
        println(neighb)
        neighborhood_structures[neighb](data, solution)
        neighb_list_remove!(neighb, neighb_list)
    end
    println("end rvnd.")
end


# modificar para o novo formato [4 | 1 2 3 4 | 1]
function new_array_rvnd(customers)
    new_array = Array(1:length(customers)+2)
    println(new_array, length(new_array))

    iter = 2
    for i in customers
        new_array[iter] = i
        iter += 1
    end
    new_array[1] = customers[end]
    new_array[end] = customers[1]
    println(new_array)
end
# -------------------------------------------------
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