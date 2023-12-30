open("25.txt") do f
    G::Dict{String, Array{String}} = Dict()
    lines::Set{Set{String}} = Set()
    for l ∈ eachline(f)
        s, ss... = split(l, r" |: ")
        s ∉ keys(G) ? G[s] = ss : append!(G[s], ss)
        for s2 ∈ ss
            s2 ∉ keys(G) ? G[s2] = [s] : push!(G[s2], s)
            push!(lines, Set([s, s2]))
        end
    end
    ls = collect.(collect(lines))
    L = length(ls)
    N = length(keys(G))

    function isdisconnected(removed)
        start, goal = removed[3]
        Q = [start]
        seen::Set{String}=Set()
        while !isempty(Q)
            n = popfirst!(Q)
            n == goal && return false
            n ∈ seen && continue
            push!(seen, n)
            for nn ∈ G[n]
                Set([n, nn]) ∈ removed && continue
                push!(Q, nn)
            end
        end
        a = length(seen)
        b = N - a
        println("Answer: ", a*b)
        return true
    end

    function cutcandidates()
        nodes = collect(keys(G))
        iter = 0
        iters = N-1
        start = nodes[1]
        # Find a stop node on the other side of the partition
        # using maxflow algorithm. When found, return cut candidates.
        for stop ∈ nodes[2:end]
            flowlines::Set{Set{String}} = Set()
            maxflow = 0
            done = false
            while !done
                done = true
                seen::Set{String} = Set()
                Q = [(start, Array{Set{String}}([]))]
                quickstop = min(length(G[start]), length(G[stop]))
                while !isempty(Q) && maxflow < quickstop
                    n, path = popfirst!(Q)
                    if n == stop
                        maxflow += 1
                        push!(flowlines, path...)
                        done = false
                        break
                    end
                    n ∈ seen && continue
                    push!(seen, n)
                    for nn ∈ G[n]
                        nn ∈ seen && continue
                        nline = Set([n, nn])
                        nline ∈ flowlines && continue
                        push!(Q, (nn, push!(deepcopy(path), Set([n,nn]))))
                    end
                end
            end
            iter += 1
            maxflow==3 && return flowlines
        end
    end

    cuts = collect(cutcandidates())
    C = length(cuts)
    for i∈1:C-2, j∈i+1:C-1, k∈j+1:C
        removed = [cuts[i], cuts[j], cuts[k]]
        isdisconnected(removed) && break
    end
end