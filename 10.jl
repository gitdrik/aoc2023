open("10.txt") do f
    M = readlines(f)
    S = nothing
    for (row, l) ∈ enumerate(M), (col, c) ∈ enumerate(l)
        if c=='S'
            S = (row, col)
            break
        end
    end
    pipes = Dict(
        'F'=>[( 1, 0), ( 0, 1)],
        '-'=>[( 0, 1), ( 0,-1)],
        '7'=>[( 0,-1), ( 1, 0)],
        '|'=>[(-1, 0), ( 1, 0)],
        'J'=>[(-1, 0), ( 0,-1)],
        'L'=>[(-1, 0), ( 0, 1)],
        'S'=>[(-1, 0)] #Defines the direction to leave S
    )
    leftside = Dict(
        ( 0, 1)=>(-1, 0),
        ( 1, 0)=>( 0, 1),
        ( 0,-1)=>( 1, 0),
        (-1, 0)=>( 0,-1)
    )
    # Walk around the tube.
    seen::Set{Tuple{Int, Int}} = Set()
    left::Set{Tuple{Int, Int}} = Set()
    Q = [S]
    while !isempty(Q)
        row, col = pop!(Q)
        (row, col) ∈ seen && continue
        push!(seen, (row, col))
        for (dr, dc) ∈ pipes[M[row][col]]
            if (row+dr, col+dc) ∉ seen
                push!(left, (row, col) .+ leftside[(dr, dc)])
                push!(left, (row+dr, col+dc) .+ leftside[(dr, dc)])
                push!(Q, (row+dr, col+dc))
            end
        end
    end
    println("Part 1: ", length(seen)÷2)

    inside::Set{Tuple{Int, Int}} = Set()
    # All inside are left of tube, find them.
    for pos ∈ left
        Q = [pos]
        while !isempty(Q)
            p = pop!(Q)
            p ∈ seen && continue
            p ∈ inside && continue
            push!(inside, p)
            for dp ∈ [(1,0), (-1,0), (0,1), (0,-1)]
                push!(Q, p .+ dp)
            end
        end
    end
    println("Part 2: ", length(inside))
end