open("11.txt") do f
    I = readlines(f)
    rows = length(I)
    cols = length(I[1])
    G::Array{Tuple{Int, Int}} = []
    ER::Array{Int} = []
    notEC::Set{Int} = Set()
    for r ∈ 1:rows
        empty = true
        for c ∈ 1:cols
            if I[r][c]=='#'
                push!(G, (r,c))
                push!(notEC, c)
                empty = false
            end
        end
        empty && push!(ER, r)
    end
    EC = [c for c ∈ 1:cols if c ∉ notEC]

    function dist(expansion)
        d = 0
        for i ∈ 1:length(G)-1, j ∈ i+1:length(G)
            r1, r2 = minmax(G[i][1], G[j][1])
            c1, c2 = minmax(G[i][2], G[j][2])
            d += r2+c2-r1-c1
            d += expansion * sum(r ∈ r1:r2 for r∈ER)
            d += expansion * sum(c ∈ c1:c2 for c∈EC)
        end
        return d
    end
    println("Part 1: ", dist(1))
    println("Part 2: ", dist(999999))
end
