module ReadData

include("./DataMD.jl")
using .DataMD

export loadData

struct Coord 
    x::Float64
    y::Float64
end

struct GeoLocation
    lat::Float64
    lng::Float64
end

function loadData(file_name::String)
    open(ARGS[1], "r") do file 
        x = read(file, String)
        dt = split(join(split(x, ":")))

        name = dt[findfirst(nm->nm == "NAME", dt)+1]
        dim = parse(Int, dt[findfirst(nm->nm == "DIMENSION", dt)+1])

        data = Data(name, dim, zeros(Float64, dim, dim))

        ewt = dt[findfirst(nm->nm == "EDGE_WEIGHT_TYPE", dt)+1]

        if ewt == "EXPLICIT"
            ewf = dt[findfirst(nm->nm == "EDGE_WEIGHT_FORMAT", dt)+1]
            start_index = findfirst(nm->nm == "EDGE_WEIGHT_SECTION", dt)

            if ewf == "FULL_MATRIX"
                
                count = 1
                for i in 1:data.dimension
                    for j in 1:data.dimension
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        count = count + 1
                    end
                end
            
            elseif ewf == "UPPER_ROW"
                
                count = 1
                for i in 1:data.dimension
                    for j in i+1:data.dimension
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        data.distance_matrix[j,i] = data.distance_matrix[i,j]
                        count = count+1
                    end
                end

                
            elseif ewf == "LOWER_ROW"
                
                count = 1
                for i in 1:data.dimension
                    for j in 1:i
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        data.distance_matrix[j,i] = data.distance_matrix[i,j]
                        count = count+1
                    end
                end
                

            elseif ewf == "UPPER_DIAG_ROW"
                
                count = 1
                for i in 1:data.dimension
                    for j in i:data.dimension
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        data.distance_matrix[j,i] = data.distance_matrix[i,j]
                        count = count+1
                    end
                end
                
            
            elseif ewf == "LOWER_DIAG_ROW"
                
                count = 1
                for i in 1:data.dimension
                    for j in 1:i
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        data.distance_matrix[j,i] = data.distance_matrix[i,j]
                        count = count+1
                    end
                end
                

            elseif ewf == "LOWER_DIAG_ROW"
                
                count = 1
                for i in 1:data.dimension
                    for j in 1:i
                        data.distance_matrix[i,j] = parse(Float64, dt[start_index+count])
                        data.distance_matrix[j,i] = data.distance_matrix[i,j]
                        count = count+1
                    end
                end
                
            end

        elseif ewt == "EUC_2D"
            start_index = findfirst(nm->nm == "NODE_COORD_SECTION", dt)
            count = 1
            temp_coord = []

            for i in 1:data.dimension
                x = parse(Float64, dt[start_index+count+1])
                y = parse(Float64, dt[start_index+count+2])
                
                push!(temp_coord, Coord(x, y))
                count = count + 3
            end

            for i in 1:data.dimension
                for j in 1:data.dimension
                    data.distance_matrix[i,j] = floor( calc_dist_eucl(temp_coord[i], temp_coord[j]) + 0.5)
                end
            end


        elseif ewt == "CEIL_2D"
            start_index = findfirst(nm->nm == "NODE_COORD_SECTION", dt)
            count = 1
            temp_coord = []

            for i in 1:data.dimension
                x = parse(Float64, dt[start_index+count+1])
                y = parse(Float64, dt[start_index+count+2])
                
                push!(temp_coord, Coord(x, y))
                count = count + 3
            end

            for i in 1:data.dimension
                for j in 1:data.dimension
                    data.distance_matrix[i,j] = ceil(calc_dist_eucl(temp_coord[i], temp_coord[j]))
                end
            end
        
        elseif ewt == "GEO"

            start_index = findfirst(nm->nm == "NODE_COORD_SECTION", dt)
            count = 1
            temp_geo = []

            for i in 1:data.dimension
                lat = parse(Float64, dt[start_index+count+1])
                lng = parse(Float64, dt[start_index+count+2])
                
                push!(temp_geo, GeoLocation(lat, lng))
                println(lat," ", lng)
                count = count + 3
            end

            for i in 1:data.dimension
                for j in 1:data.dimension
                    data.distance_matrix[i,j] = calc_dist_geo(temp_geo[i], temp_geo[j])
                    # println(calc_dist_geo(temp_geo[i], temp_geo[j]))
                end
            end
        end
        println(data.name, " - ", data.dimension)
        show_matrix(data.distance_matrix)
        # return data
    end
end

function show_matrix(matrix)
    dim = size(matrix)
    for i in 1:dim[1]
        for j in 1:dim[2]
            print(matrix[i,j], " ")
        end
        print("\n")
    end
end

function calc_dist_eucl(p1::Coord, p2::Coord)
    return sqrt( (p2.x - p1.x)^2 + (p2.y - p1.y)^2 )
end

function calc_dist_geo(p1::GeoLocation, p2::GeoLocation) 
    RRR = 6378.388

    q1 = cos(p1.lng - p2.lng)
    q2 = cos(p1.lat - p2.lat)
    q3 = cos(p1.lat + p2.lat)

    value = (RRR * acos( 0.5*((1.0+q1)*q2 - (1.0-q1)*q3) ) + 1.0)
    return trunc(value)
end

end