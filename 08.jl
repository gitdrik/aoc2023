open("08.txt") do f
    LR = readline(f)
    @assert readline(f)==""
    G::Dict{String, Array{String}} = Dict()
    for l ∈ eachline(f)
        a, b, c = l[1:3], l[8:10], l[13:15]
        G[a] = [b, c]
    end

    p1, pos = 0, "AAA"
    while pos ≠ "ZZZ"
        p1 += 1
        c = LR[mod1(p1, length(LR))]
        pos = c=='L' ? G[pos][1] : G[pos][2]
    end
    println("Part 1: ", p1)

    pos = [a for a ∈ keys(G) if a[3]=='A']
    cycles = fill(0, length(pos))
    for i ∈ eachindex(pos)
        while pos[i][3] ≠ 'Z'
            cycles[i] += 1
            c = LR[mod1(cycles[i], length(LR))]
            pos[i] = c=='L' ? G[pos[i]][1] : G[pos[i]][2]
        end
    end
    println("Part 2: ", lcm(cycles))
end