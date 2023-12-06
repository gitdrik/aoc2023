open("06.txt") do f
    T = parse.(Int, split(readline(f))[2:end])
    D = parse.(Int, split(readline(f))[2:end])

    wins(t, d) = t - 2*Int((t - sqrt(t^2 - 4*d))÷2) - 1
    println("Part 1: ", prod([wins(t, d) for (t, d) ∈ zip(T,D)]))

    T = parse(Int, join(string.(T)))
    D = parse(Int, join(string.(D)))
    println("Part 2: ", wins(T, D))
end