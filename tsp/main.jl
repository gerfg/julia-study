include("./ReadData.jl")
include("./ILS.jl")
import .ReadData
import .ILS

data = ReadData.loadData(ARGS[1])
ILS.run(data)