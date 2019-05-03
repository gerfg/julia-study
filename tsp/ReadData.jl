module ReadData

include("./DataMD.jl")
using .DataMD

export loadData

function loadData(file_name::String)
    println("LOAD_DATA Start:")
    open(ARGS[1], "r") do file 
        x = read(file, String)
        dt = split(join(split(x, ":")))

        # println(dt)
        println("\t>Data readed.")

        name = dt[findfirst(nm->nm == "NAME", dt)+1]
        dim = parse(Int, dt[findfirst(nm->nm == "DIMENSION", dt)+1])

        data = Data(name, dim, zeros(Float64, dim, dim))
        println("\t>Data Obj created.")
        # println(data)

        ewt = dt[findfirst(nm->nm == "EDGE_WEIGHT_TYPE", dt)+1]
        println("\t>Edge type: ", ewt, ".")

        if ewt == "EXPLICIT"
            ewf = dt[findfirst(nm->nm == "EDGE_WEIGHT_FORMAT", dt)+1]

            if ewf == "FULL_MATRIX"
                start_index = findfirst(nm->nm == "EDGE_WEIGHT_SECTION", dt)
                count = 1
                
                for i in data.dimension
                    for j in data.dimension
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        count = count + 1
                        print(dt[start_index+count])
                    end
                    count = count +1
                    println()
                end
                # for i in 
                    # println(length(dt[start_index:(start_index + (dim*dim))]))
                # end
                # println(data)
            end
            
        end

        # return data
    end
end

end