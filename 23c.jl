open("23.txt") do f
    M = collect.(readlines(f))
    dp = [(0,1), (1,0), (0,-1), (-1,0)]
    dpc = ['>','v','<','^']
    goal = (141, 140)
#    goal = (23,22)

    MEM=Dict()
    function walk(r, c, d, path)
        (r, c)==goal && return 0
        (r,c,d,path) ∈ keys(MEM) && return MEM[(r,c,d,path)]

        nxt::Array{NTuple{3, Int}} = []
        for nd ∈ mod1.(d-1:d+1, 4)
            nr, nc = (r, c) .+ dp[nd]
            M[nr][nc]=='#' && continue
            (nr, nc) ∈ path && continue
            push!(nxt, (nr, nc, nd))
        end
        length(nxt) == 0 && return typemin(Int)

        if length(nxt) > 1
            path = push!(deepcopy(path), (r, c))
        end
        ans = typemin(Int)
        for (nr, nc, nd) ∈ nxt
            ans = max(ans, 1 + walk(nr, nc, nd, path))
        end

        MEM[(r,c,d,path)] = ans
        return ans
    end
    println(walk(1, 2, 2, Set()))
end
