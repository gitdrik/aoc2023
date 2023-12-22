open("22.txt") do f
    brix::Array{NTuple{3, UnitRange}} = []
    for l ∈ eachline(f)
        x1, y1, z1, x2, y2, z2 = parse.(Int, split(l, r",|~"))
        push!(brix, (z1:z2, x1:x2, y1:y2))
    end
    sort!(brix)
    
    pile::Dict{NTuple{3,Int}, Int} = Dict()
    below::Array{Set{Int}} = [Set() for _ ∈ eachindex(brix)]
    above::Array{Set{Int}} = [Set() for _ ∈ eachindex(brix)]
    for i ∈ eachindex(brix)
        zr, xr, yr = brix[i]
        while true
            zr.start==1 && break
            any([(zr.start-1, x, y)∈keys(pile) for x∈xr, y∈yr]) && break
            zr = zr .- 1
        end
        for x∈xr, y∈yr
            if (zr.start-1, x, y) ∈ keys(pile)
                push!(below[i], pile[(zr.start-1, x, y)])
                push!(above[pile[(zr.start-1, x, y)]], i)
            end
        end
        brix[i] = (zr, xr, yr)
        for z∈zr, x∈xr, y∈yr
            pile[(z, x, y)] = i
        end
    end

    p1 = 0
    for i ∈ eachindex(brix)
        free = true
        for j ∈ above[i]
            if length(below[j])==1
                free = false
                break
            end
        end
        p1 += free
    end
    println("Part 1: ", p1)

    p2 = 0
    for i ∈ eachindex(brix)
        Q = [b for b ∈ above[i]]
        deleted::Set{Int} = Set([i])
        while !isempty(Q)
            j = popfirst!(Q)
            if all(k∈deleted for k∈below[j])
                push!(deleted, j)
                append!(Q, above[j])
            end
        end
        p2 += length(deleted)-1
    end
    println("Part 2: ", p2)

end