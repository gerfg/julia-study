println(ARGS[1])

data = [];

open(ARGS[1], "r") do file 
    x = read(file, String)
    println(split(x))
end
