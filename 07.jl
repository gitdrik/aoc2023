using DataStructures

open("07.txt") do f
    hands = [[hand, parse(Int, bid)] for (hand, bid) ∈ split.(readlines(f))]
    ordering = "23456789TJQKA"
    strength = Dict([(c, i) for (i, c) ∈ enumerate(ordering)])
    hands = [[[strength[c] for c ∈ h], h, bid] for (h, bid) ∈ hands]
    sort!(hands)

    five(h) = length(Set(h[2]))==1
    four(h) = length(Set(h[2]))==2 && (count(h[2][1], h[2])==4 || count(h[2][1], h[2])==1)
    full(h) = length(Set(h[2]))==2 && !four(h)
    three(h) = length(Set(h[2]))==3 && (
        count(h[2][1], h[2])==3 || count(h[2][1], h[2])==1 && count(h[2][2], h[2])!=2)
    two(h) = length(Set(h[2]))==3 && !three(h)
    one(h) = length(Set(h[2]))==4
    high(h) = length(Set(h[2]))==5

    catsort(hands) = [
        filter(high, hands);
        filter(one, hands);
        filter(two, hands);
        filter(three, hands);
        filter(full, hands);
        filter(four, hands);
        filter(five, hands);
    ]
    p1 = sum([i*h[3] for (i, h) ∈ enumerate(catsort(hands))])
    println("Part 1: ", p1)

    ordering = "J23456789TQKA"
    strength = Dict([(c, i) for (i, c) ∈ enumerate(ordering)])
    hands = [[[strength[c] for c ∈ h], h, bid] for (_, h, bid) ∈ hands]
    sort!(hands)
    for (i, h) ∈ enumerate(hands)
        'J' ∉ h[2] && continue
        if high(h) || four(h) || full(h)
            _, m = findmax(h[1])
            hands[i][2] = replace(hands[i][2], 'J'=>h[2][m])
        elseif one(h) || three(h)
            cc = [c for (c, v) in counter(h[2]) if v≥2][1]
            if cc == 'J'
                _, m = findmax(h[1])
                hands[i][2] = replace(hands[i][2], 'J'=>h[2][m])
            else
                hands[i][2] = replace(hands[i][2], 'J'=>cc)
            end            
        elseif two(h)
            lone = findfirst([c for (c, v) in counter(h[2]) if v==1][1], h[2])
            maxpair = maximum([n for (j, n) ∈ enumerate(h[1])  if j ≠ lone])
            m = findfirst(==(maxpair), h[1])
            hands[i][2] = replace(hands[i][2], 'J'=>h[2][m])
        end
    end
    p2 = sum([i*h[3] for (i, h) ∈ enumerate(catsort(hands))])
    println("Part 2: ", p2)
end