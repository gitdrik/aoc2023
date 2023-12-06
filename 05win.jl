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
    
    function transform(t, n)
        for (range, delta) ∈ t
            n ∈ range && return n+delta
        end
        return n
    end
    for t ∈ T
        nums = [transform(t, n) for n ∈ nums]
    end
    println("Part 1: ", minimum(nums))
    
    function detransform(t, n)
        for (range, delta) ∈ t
            (n-delta) ∈ range && return n-delta
        end
        return n
    end
    for p ∈ Iterators.countfrom(0)
        pp = p
        for t ∈ reverse(T)
            pp = detransform(t, pp)
        end
        if any(pp ∈ r for r ∈ ranges)
            println("Part 2: ", p)
            break
        end
    end
    
end
