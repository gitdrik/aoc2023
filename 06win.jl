function race()
    T = [40, 82, 84, 92]
    D = [233, 1011, 1110, 1487]

    p1 = 1
    for (i, t) ∈ enumerate(T)
        wins = 0
        for pt ∈ 0:t
            d = pt*(t-pt)
            wins += d > D[i]
        end
        p1 *= wins
    end
    println("Part 1: ", p1)

    T = parse(Int, join(string.(T)))
    D = parse(Int, join(string.(D)))
    start = 0
    while start*(T-start) < D
        start +=1
    end
    println("Part 2: ", T+1 - 2*start)
end
race()