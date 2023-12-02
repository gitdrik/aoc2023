open("02.txt") do f
    p1, p2 = 0, 0
    bmax = [12, 13, 14]
    ci = Dict('r'=>1, 'g'=>2, 'b'=>3)
    for (g, l) ∈ enumerate(eachline(f))
        bmin = [0, 0, 0]
        ss = split(l,' ')
        for i = 3:2:length(ss)
            n, c = parse(Int, ss[i]), ss[i+1][1]
            bmin[ci[c]] = max(n, bmin[ci[c]])
        end
        all(bmin .≤ bmax) && (p1 += g)
        p2 += prod(bmin)
    end
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end