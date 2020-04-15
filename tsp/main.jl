include("./ReadData.jl")
include("./ILS.jl")

if isempty(ARGS) || length(ARGS) > 1
    print("Caminho para arquivo de instância inválido!\n")
    exit(1)
end

data = ReadData.loadData(ARGS[1])

ILS_RVND.run(data)
# @time begin
# end