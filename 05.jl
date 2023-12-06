open("05.txt") do f
    nums = parse.(Int, split(readline(f))[2:end])
    ranges = [a:(a+b-1) for (a, b) ∈ zip(nums[1:2:end], nums[2:2:end])]
    maps = read(f, String) |> strip |> s->split(s, "\n\n") .|> s->split(s, "\n")
    t::Array{Tuple{UnitRange, Int}} = []
    T::Array{Array{Tuple{UnitRange, Int}}} = []
    for m ∈ maps
        for l ∈ m
            !isdigit(l[1]) && continue
            a, b, c = parse.(Int, split(l))
            range = b:b+c-1
            delta = a - b
            push!(t, (range, delta))
        end
        push!(T, sort(t))
        t = []
    end
        
    function transform_num(t, n)
        for (range, delta) ∈ t
            n ∈ range && return n+delta
        end
        return n
    end
    for t ∈ T
        nums = [transform_num(t, n) for n ∈ nums]
    end
    println("Part 1: ", minimum(nums))

    function transform_range(t, r)
        rs = []
        r.stop < t[1][1].start && return [r]
        r.start > t[end][1].stop && return [r]
        if r.start < t[1][1].start
            push!(rs, r.start:t[1][1].start-1)
            r = t[1][1].start:r.stop
        end
        if r.stop > t[end][1].stop
            push!(rs, t[end][1].stop+1:r.stop)
            r = r.start:t[end][1].stop
        end
        for (range, delta) ∈ t
            ir = r ∩ range
            push!(rs, ir.start+delta:ir.stop+delta)
        end
        rs = [r for r ∈ rs if length(r) > 0]
        return rs
    end
    for t ∈ T
        ranges = vcat([transform_range(t, r) for r ∈ ranges]...)
    end
    println("Part 2: ", minimum(minimum.(ranges)))    
end