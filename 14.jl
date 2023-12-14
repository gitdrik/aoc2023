open("14.txt") do f
    l = readlines(f)
    rows, cols = length(l), length(l[1])
    S = falses(rows, cols)
    B = falses(rows, cols)
    for r∈1:rows, c∈1:cols
        S[r,c] = l[r][c]=='#'
        B[r,c] = l[r][c]=='O'
    end

    function north!(B)
        done = false
        while !done
            done = true
            for r∈2:rows, c∈1:cols
                !B[r,c] && continue
                (B[r-1,c] || S[r-1,c]) && continue
                B[r,c] = false
                B[r-1,c] = true
                done = false
            end
        end
        return B
    end

    function west!(B)
        done = false
        while !done
            done = true
            for c∈2:cols, r∈1:rows
                !B[r,c] && continue
                (B[r,c-1] || S[r,c-1]) && continue
                B[r,c] = false
                B[r,c-1] = true
                done = false
            end
        end
        return B
    end

    function south!(B)
        done = false
        while !done
            done = true
            for r∈rows-1:-1:1, c∈1:cols
                !B[r,c] && continue
                (B[r+1,c] || S[r+1,c]) && continue
                B[r,c] = false
                B[r+1,c] = true
                done = false
            end
        end
        return B
    end

    function east!(B)
        done = false
        while !done
            done = true
            for c∈cols-1:-1:1, r∈1:rows
                !B[r,c] && continue
                (B[r,c+1] || S[r,c+1]) && continue
                B[r,c] = false
                B[r,c+1] = true
                done = false
            end
        end
        return B
    end

    north!(B)
    p1 = sum([sum(B[r,:]) * (rows+1-r) for r∈1:rows])
    println("Part 1: ", p1)

    i = 0
    seen::Array{BitMatrix} = []
    while true
        north!(B)
        west!(B)
        south!(B)
        east!(B)
        i += 1
        B ∈ seen && break
        push!(seen, deepcopy(B))
    end
    goal = 1000000000
    start = findfirst(==(B), seen)
    cycle = i-start
    goaleq = (goal-start)%cycle + start
    B = seen[goaleq]
    p2 = sum([sum(B[r,:]) * (rows+1-r) for r∈1:rows])
    println("Part 2: ", p2)
end