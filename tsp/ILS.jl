module ILS_RVND

include("./DataMD.jl")
include("./SolutionMD.jl")
include("./rvnd/rvnd.jl")

export run

function run(data)
    max_iter_ils = 50

    best_sol = SolutionMD.Solution() # s*
    ils_loop_sol = SolutionMD.Solution() # s
    current_best_sol = SolutionMD.Solution() # s'

    if data.dimension < 150
        max_iter_ils = data.dimension
    else
        max_iter_ils = data.dimension/2
    end

    # for iter in 1:max_iter_ils
        
        ils_loop_sol = initial_solution(data) # construction
        # current_best_sol = deepcopy(ils_loop_sol) # s' = s 
        # iter_ils = 0
        # while iter_ils < max_iter_ils
            # rvnd
            RVND.run(data, ils_loop_sol)
        # end
    # end
end

function initial_solution(data)
    candidate_list = Array(1:data.dimension)
    solution = SolutionMD.Solution()

    num_random_clients = 3
    for i = 1:num_random_clients
        client = get_random_client!(candidate_list)
        SolutionMD.append_client!(solution, client)
    end
    SolutionMD.update_cost!(solution, data)

    while length(candidate_list) > 0
        client = get_random_client!(candidate_list)
        cheaper_insertion!(solution, data, client)
    end

    println("Initial Solution: ", solution)
    return solution
end

function cheaper_insertion!(sol, data, customer_evaluate)
    best_cost = Inf
    position = 0
    
    for i = 2:length(sol.customers)
        customer_behind, customer = sol.customers[i-1], sol.customers[i]

        computed_cost = 0.0
        computed_cost -= data.distance_matrix[customer_behind, customer]
        computed_cost += data.distance_matrix[customer_behind, customer_evaluate] + data.distance_matrix[customer_evaluate, customer]

        if computed_cost < best_cost
            best_cost = computed_cost
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