using DataStructures

open("15.txt") do f
    S = split(readline(f), ',')

    function hash(s)
        v = 0
        for c ∈ s
            v += Int(c)
            v *= 17
            v %= 256
        end
        return v
    end
    println("Part 1: ", sum(hash.(S)))
 
    boxes::Dict{Int,OrderedDict{String, Int}} = Dict()
    for s ∈ S
        lbl, n = split(s, r"-|=")
        box = hash(lbl)+1
        op = s[length(lbl)+1]

        if op=='-' && box ∈ keys(boxes)
            delete!(boxes[box], lbl)
        elseif op=='='
            lens = parse(Int, n)
            box ∉ keys(boxes) && (boxes[box]=OrderedDict())
            boxes[box][lbl] = lens
        end
    end

    p2 = 0
    for (i, b) ∈ boxes
        for (j, l) ∈ enumerate(b)
            p2 += i*j*l[2]
        end
    end
    println("Part 2: ", p2)
end