open("09.txt") do f
    S = [parse.(Int, split(l)) for l∈ eachline(f)]
    dS(s) = [b-a for (a, b) ∈ zip(s, s[2:end])]
    next(s) = all(s.==0) ? 0 : s[end] + next(dS(s))
    println("Part 1: ", sum(next.(S)))
    prev(s) = all(s.==0) ? 0 : s[1] - prev(dS(s))
    println("Part 2: ", sum(prev.(S)))
end