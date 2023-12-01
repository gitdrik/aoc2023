open("01.txt") do f
    p1, p2 = 0, 0
    for l ∈ eachline(f)
        lf = filter(isdigit, l)
        p1 += parse(Int, lf[1]*lf[end])

        digs = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        for i ∈ eachindex(l), (j, d) ∈ enumerate(digs)
            if startswith(l[i:end], d) || l[i]==string(j)
                p2 += j*10
                break
            end
        end
        for i ∈ length(l):-1:1, (j, d) ∈ enumerate(digs)
            if endswith(l[1:i], d) || l[i]==string(j)
                p2 += j
                break
            end
        end
    end
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end