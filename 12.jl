open("12.txt") do f
    p1, p2 = 0, 0
    for l ∈ eachline(f)
        s, ns = split(l)
        ns = parse.(Int, split(ns,','))

        s2 = s*'?'*s*'?'*s*'?'*s*'?'*s
        ns2 = repeat(ns, 5)

        MEM::Dict{Tuple{String, Array{Int}}, Int} = Dict()
        function solve(s, ns)
            isempty(ns) && return '#' ∉ s
            length(s) < sum(ns)+length(ns)-1 && return 0
            (s, ns) ∈ keys(MEM) && return MEM[(s, ns)]
            ans = 0
            if s[1] ≠ '#'
                ans += solve(s[2:end], ns)
            end
            if '.' ∉ s[1:ns[1]] && (length(s)==ns[1] || '#' ∉ s[ns[1]+1:ns[1]+1])
                ans += solve(s[ns[1]+2:end], ns[2:end])
            end
            MEM[(s, ns)] = ans
            return ans
        end
        p1 += solve(s, ns)
        p2 += solve(s2, ns2)
    end
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end