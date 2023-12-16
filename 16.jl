open("16.txt") do f
    M = collect.(readlines(f))
    R = eachindex(M)
    C = eachindex(M[1])

    function op(c, dr, dc)
        c=='/' && return [(-dc, -dr)]
        c=='\\' && return [(dc, dr)]
        c=='-' && dr ≠ 0 && return [(0, 1), (0, -1)]
        c=='|' && dc ≠ 0 && return [(1, 0), (-1, 0)]
        return [(dr, dc)]
    end

    function energize(r, c, dr, dc)
        energized::Set{Tuple{Int,Int}} = Set()
        Q::Array{Tuple{Int,Int,Int,Int}} = [(r, c, dr, dc)]
        seen::Set{Tuple{Int,Int,Int,Int}} = Set()
        while !isempty(Q)
            r, c, dr, dc = pop!(Q)
            (r, c, dr, dc) ∈ seen && continue
            push!(seen, (r, c, dr, dc))
            push!(energized, (r, c))
            for (dr, dc) ∈ op(M[r][c], dr, dc)
                (r+dr ∉ R || c+dc ∉ C) && continue
                push!(Q, (r+dr, c+dc, dr, dc))
            end
        end
        return length(energized)
    end

    println("Part 1: ", energize(1, 1, 0, 1))

    p2 = 0
    for r ∈ R
        p2 = max(p2, energize(r, 1, 0, 1))
        p2 = max(p2, energize(r, C.stop, 0, -1))
    end
    for c ∈ C
        p2 = max(p2, energize(1, c, 1, 0))
        p2 = max(p2, energize(R.stop, c, -1, 0))
    end
    println("Part 2: ", p2)
end