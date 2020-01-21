module ILS

include("./DataMD.jl")
include("./SolutionMD.jl")

export run

function run(data)
    iter_ils = 0
    maxIter_ils = 50

    if data.dimension < 150
        max_iter_ils = data.dimension
    else
        max_iter_ils = data.dimension/2
    end

    initial_solution(data)
    # for iter in 1:iterils
        
        # println(typeof(candidate_list), "\n" ,candidate_list)
        # println(candidate_list[5])
        # filter!(x->x≠5, candidate_list)
        # println(typeof(candidate_list), "\n" ,candidate_list)
    # end
end

function initial_solution(data)
    candidate_list = Array(1:data.dimension)
    solution = SolutionMD.Solution()
    
    for i = 1:5
        client = get_random_client!(candidate_list)
        SolutionMD.append_client!(solution, client)
    end
    SolutionMD.update_cost!(solution, data)

    while length(candidate_list) > 0
        client = get_random_client!(candidate_list)
        cheaper_insertion!(solution, data, client)
    end

    println(solution)
end

function cheaper_insertion!(sol, data, customer_evaluate)
    best_cost = Inf
    position = 0
    
    for i = 2:length(sol.customers)
        customer_behind, customer = sol.customers[i-1], sol.customers[i]

        cost = 0.0
        cost -= data.distance_matrix[customer_behind, customer]
        cost += data.distance_matrix[customer_behind, customer_evaluate] + data.distance_matrix[customer_evaluate, customer]

        if cost < best_cost
            best_cost = cost
            position = i
        end
    end
    insert!(sol.customers, position, customer_evaluate)
    SolutionMD.update_cost!(sol, data)
end

function get_random_client!(candidate_list::Array{Int})
    random_position = rand(1:length(candidate_list))
    random_client = candidate_list[random_position]
    deleteat!(candidate_list, random_position)

    return random_client
end

end