open("12.txt") do f
    p1, p2 = 0, 0
    for (i, l) ∈ enumerate(eachline(f))
        s, ns = split(l)
        ns = parse.(Int, split(ns,','))

        s2 = s*'?'*s*'?'*s*'?'*s*'?'*s
        ns2 = repeat(ns, 5)

        MEM::Dict{Tuple{Array{Int}, Int}, Int} = Dict()
        function extend(s, ns, ndig)
            isempty(ns) && return 1
            (ns, ndig) ∈ keys(MEM) && return MEM[(ns, ndig)]

            ans = 0
            n = ns[1]
            last = length(ns)==1
            maxdots = ndig-sum(ns)-length(ns)+1            

            for d ∈ 0:maxdots
                ext = '.'^d * '#'^n * '.'^!last
                last && (ext *= '.'^(ndig-length(ext)))
                ts = s[end-ndig+1:end-ndig+length(ext)]
                rts = Regex(replace(replace(ts, "."=>"\\."), '?'=>'.'))
                !occursin(rts, ext) && continue
                ans += extend(s, ns[2:end], ndig-length(ext))
            end
            MEM[(ns, ndig)] = ans
            return ans
        end
        p1 += extend(s, ns, length(s))
        p2 += extend(s2, ns2, length(s2))
    end
    println("Part 1: ", p1)
    println("Part 2: ", p2)
end