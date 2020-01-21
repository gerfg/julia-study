module SolutionMD

include("DataMD.jl")

mutable struct Solution
    customers::Array{Int}
    cost::Float64

    Solution() = new(Array{Int, 1}(undef, 0), 0.0)
end

function add_client_to!(sol, client, position)
    insert!(sol.customers, position, client)
end

function append_client!(sol::Solution, client::Int)
    append!(sol.customers, client)
end

function update_cost!(sol, data)
    sol.cost = 0.0
    for i = 2:length(sol.customers)
        cust_behind, cust = sol.customers[i-1], sol.customers[i]
        sol.cost += data.distance_matrix[cust_behind, cust]
    end

    last_client = sol.customers[end]
    first_client = sol.customers[1]
    sol.cost += data.distance_matrix[last_client, first_client]
end

end