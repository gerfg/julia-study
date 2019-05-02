println("Hello World!")

function pow(a::Int64, exp::Float64)
    return a^exp
end

println(pow(2,2.0))


s1 = "Geraldo Figueiredo"
println(s1)

s2 = "15"
println(typeof(s2))
println(typeof(parse(Int, s2)))

s2 = "90"
println(typeof(s2))