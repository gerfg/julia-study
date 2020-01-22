
function swap(data, solution)
    println("--- Swap ---")
    for i = 1:length(solution.customers)
        for j = i:length(solution.customers)
            if i != j 
                println(solution.customers[i],",",solution.customers[j])
            end
        end
    end
end