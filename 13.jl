open("13.txt") do f
    P = split.(split(read(f, String), "\n\n"), "\n")
    
    function mirror(b, smudge)
        C = size(b, 2)
        for c ∈ 1:C-1
            left  = b[:, c:-1:max(1, 2*c-C+1)]
            right = b[:, c+1:min(end, 2c)]
            if smudge
                sum(left.≠right)==1 && return c
            else
                left==right && return c
            end
        end
        return 0
    end

    p1, p2 = 0, 0
    B::Array{BitArray} = []
    for p ∈ P
        b = BitArray(undef, length(p), length(p[1]))
        for (r, l) ∈ enumerate(p), (c, ch) ∈ enumerate(l)
            b[r,c] = ch=='#'
        end
        
        p1 += mirror(b, false) + 100*mirror(rotl90(b), false)
        p2 += mirror(b, true) + 100*mirror(rotl90(b), true)
    end
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end