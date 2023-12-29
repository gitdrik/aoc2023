open("23.txt") do f
    M = collect.(readlines(f))
    dp = [(0,1), (1,0), (0,-1), (-1,0)]
    dpc = ['>','v','<','^']
    goal = (141, 140)
    Q = [(1, 2, 2, 0)]
    p1 = 0
    while !isempty(Q)
        r, c, d, steps = pop!(Q)
        if (r, c)==goal
            p1 = max(p1, steps)
            continue
        end
        for nd ∈ mod1.(d-1:d+1, 4)
            nr, nc = (r, c) .+ dp[nd]
            M[nr][nc] ∉ ['.', dpc[nd]] && continue
            push!(Q, (nr, nc, nd, steps+1))
        end
    end
    println("Part 1: ", p1)
end
