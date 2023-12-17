using DataStructures

open("17.txt") do f
    M = [parse.(Int, collect(l)) for l ∈ eachline(f)]
    R = length(M)
    C = length(M[1])

    function solve(minsteps, maxsteps)
        seen::Dict{Tuple{Int,Int,Int,Int}, Int} = Dict()
        dp = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        Q = SortedSet([(0, 1, 1, 3, 0)])
        while !isempty(Q)
            h, r, c, d, steps = pop!(Q)
            (r, c)==(R, C) && return h
            (r, c, d, steps) ∈ keys(seen) && seen[(r, c, d, steps)] ≤ h && continue
            for s ∈ steps:maxsteps
               seen[(r, c, d, s)] = h
            end
            for nd ∈ d-1:d+1
                nd = mod1(nd, 4)
                nd==d && steps==maxsteps && continue
                nd≠d && steps < minsteps && continue
                nsteps = nd≠d ? 0 : steps
                nr, nc = (r, c) .+ dp[nd]
                nr∈1:R && nc∈1:C && push!(Q, (h+M[nr][nc], nr, nc, nd, nsteps+1))
            end
        end
    end
    println("Part 1: ", solve(1, 3))
    println("Part 2: ", solve(4, 10))
end