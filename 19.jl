open("19.txt") do f
    one, two = split(read(f, String),"\n\n")

    rules::Dict{String, Array{String}} = Dict()
    for r ∈ split(one)
        label, rest, _ = split(r, r"{|}")
        rules[label] = split(rest, ',')
    end

    objects = []
    for xmas ∈ split(two)
       xmas = split(xmas[2:end-1], r",|=")
       d = Dict(a=>parse(Int, b) for (a, b) ∈ zip(xmas[1:2:end],xmas[2:2:end]))
       push!(objects, d)
    end

    function test(obj, lable)
        lable=="A" && return true
        lable=="R" && return false
        for r ∈ rules[lable][1:end-1]
            t, l = split(r,':')
            if t[2]=='<'
                obj[t[1:1]] < parse(Int, t[3:end]) && return test(obj, l)
            else
                obj[t[1:1]] > parse(Int, t[3:end]) && return test(obj, l)
            end
        end
        return test(obj, rules[lable][end])
    end

    p1 = 0
    for o ∈ objects
        test(o, "in") && (p1 += sum(values(o)))
    end
    println("Part 1: ", p1)

    function test2(ranges, lable)
        lable=="A" && return prod(length.(values(ranges)))
        lable=="R" && return 0
        ranges = deepcopy(ranges)
        ans = 0
        for r ∈ rules[lable][1:end-1]
            t, l = split(r,':')
            if t[2]=='<'
                r = ranges[t[1:1]]
                v = parse(Int, t[3:end])
                r1 = r.start:min(r.stop, v-1)
                r2 = v:r.stop
                ranges[t[1:1]] = r1
                ans += test2(ranges, l)
                ranges[t[1:1]] = r2
            else
                r = ranges[t[1:1]]
                v = parse(Int, t[3:end])
                r1 = max(r.start, v+1):r.stop
                r2 = r.start:v 
                ranges[t[1:1]] = r1
                ans += test2(ranges, l)
                ranges[t[1:1]] = r2
            end
        end
        return ans + test2(ranges, rules[lable][end])
    end
    ranges = Dict("x"=>1:4000,"m"=>1:4000,"a"=>1:4000,"s"=>1:4000)
    println("Part 2: ", test2(ranges, "in"))
end