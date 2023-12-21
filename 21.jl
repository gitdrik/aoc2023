open("21.txt") do f
    M = collect.(readlines(f))
    R = length(M)
    C = length(M[1])

    function walk(need)
        stops = 0
        steps = 0
        Q = [(66, 66, 0)]
        seen::Set{NTuple{3, Int}} = Set()
        while !isempty(Q)
            (r, c, steps) = pop!(Q)
            steps > need && continue
            (r, c, steps) ∈ seen && continue
            push!(seen, (r, c, steps))
            steps==need && (stops += 1)
            for (dr, dc) ∈ [(-1,0), (0, 1), (1, 0), (0, -1)]
                M[mod1(r+dr, R)][mod1(c+dc, C)]=='#' && continue
                r+dr∈1:R && c+dc∈1:C && push!(Q, (r+dr, c+dc, steps+1))
            end
        end
        return stops
    end

    p1 = walk(64)
    println("Part 1: ", p1)

#    @show k0 = walk(65)
#    @show k1 = walk(65 + 131)
#    @show k2 = walk(65 + 2*131)
#    @show k3 = walk(65 + 3*131)

    need = 26501365
    n = need÷131
    @assert (need - n*131) / 65 == 1

    odddiamond = p1
    evendiamond = walk(65)
    oddsquare = walk(130)
    evensquare = walk(131)
    oddcorner = oddsquare - odddiamond

    stops(n) = oddsquare*n^2 + evensquare*(n^2+n) + evendiamond*(n + 1) + oddcorner*n
    println("Part 2: ", stops(n))

end