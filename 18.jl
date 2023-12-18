function run()
open("18.txt") do f
    ls = readlines(f)
    M = Set()
    r, c = 0, 0
    dp = Dict("U"=>(-1,0),"R"=>(0,1),"D"=>(1,0),"L"=>(0,-1))
    for l ∈ ls
        d, n, _ = split(l)
        for i ∈ 1:parse(Int, n)
            (r, c) = (r, c) .+ dp[d]
            push!(M, (r,c))
        end
    end
    rmin, rmax = extrema([r for (r, c) ∈ M])
    cmin, cmax = extrema([c for (r, c) ∈ M])
    O = Set()
    Q = [(rmin-1, cmin-1)]
    while !isempty(Q)
        r, c = pop!(Q)
        (r, c) ∈ O && continue
        (r, c) ∈ M && continue
        push!(O, (r ,c ))
        for nr ∈ r-1:r+1, nc ∈ c-1:c+1
            nr ∉ rmin-1:rmax+1 && continue
            nc ∉ cmin-1:cmax+1 && continue
            push!(Q, (nr, nc))
        end
    end
    println("Part 1: ", (rmax-rmin+3)*(cmax-cmin+3)-length(O))

    O = 0
    C = []
    r, c = 0, 0
    dp = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    for l ∈ ls
        d = parse(Int, l[end-1])+1
        n = parse(Int, l[end-6:end-2], base=16)
        (r, c) = (r, c) .+ dp[d].*n
        push!(C, (r, c))
        O += n
    end
    circshift!(C, 1)
    p2 = sum(C[i][1] * (C[i-1][2]-C[i][2]) for i∈2:2:length(C)) + O÷2 + 1
    println("Part 2: ", p2)
end
end