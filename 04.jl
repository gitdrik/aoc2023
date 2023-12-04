open("04.txt") do f
    p1 = 0
    C = fill(1, 204, 2)
    for (i, l) ∈ enumerate(eachline(f))
        ss = split(l[11:end])
        m = length(ss[1:10] ∩ ss[12:end])
        C[i, 1] = m
        if m > 0
            p1 += 2^(m-1)
            C[i+1:i+m, 2] .+= C[i,2]
        end
    end
    println("Part 1: ", p1)
    println("Part 2: ", sum(C[:,2]))
end