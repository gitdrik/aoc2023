open("03.txt") do f
    N::Array{Tuple{Int, Int, String}} = []
    S::Dict{Tuple{Int, Int}, Char} = Dict()
    for (i, l) ∈ enumerate(eachline(f))
        n = ""
        for (j, c) ∈ enumerate(l)
            isdigit(c) && (n *= c; continue)
            n != "" && (push!(N, (i, j-1, n)); n = "")
            c != '.' && (S[(i, j)] = c)
        end
        n !="" && push!(N, (i, 140, n))
    end

    p1 = 0
    G::Dict{Tuple{Int, Int}, Array{Int}} = Dict()
    for (i, j, n) ∈ N
        for r ∈ i-1:i+1, c ∈ j-length(n):j+1
            if (r, c) ∈ keys(S)
                nn = parse(Int, n)
                p1 += nn
                if S[(r,c)]== '*'
                    (r, c) ∈ keys(G) ? push!(G[(r, c)], nn) : G[(r,c)]=[nn]
                end
                break
            end
        end
    end
    println("Part 1: ", p1)

    p2 = 0
    for ns ∈ values(G)
        length(ns)==2 && (p2 += prod(ns))
    end
    println("Part 2: ", p2)
end