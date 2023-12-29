open("24.txt") do f
    ls = readlines(f)
    hails = length(ls)
    p = Array{Int}(undef, hails, 3)
    v = Array{Int}(undef, hails, 3)
    for (i, l) ∈ enumerate(ls)
        ns = parse.(Int, split(l, r", | @ "))
        p[i,:] = ns[1:3]
        v[i,:] = ns[4:6]
    end

    pmin = 200000000000000
    pmax = 400000000000000
    p1 = 0
    for i∈1:hails-1, j∈i+1:hails
        x01, y01 = p[i,1:2]
        vx1, vy1 = v[i,1:2]
        x02, y02 = p[j,1:2]
        vx2, vy2 = v[j,1:2]
        x =  (y02 - y01 + x01*vy1/vx1 - x02*vy2/vx2) / (vy1/vx1 - vy2/vx2)
        y = vy1/vx1 * (x - x01) + y01
        t1 = (x - x01)/vx1
        t2 = (x - x02)/vx2
        if t1 ≥ 0 && t2 ≥ 0 && pmin ≤ x ≤ pmax && pmin ≤ y ≤ pmax
            p1 += 1
        end
    end
    println("Part 1: ", p1)

    # As I happened to stumble up on, the 92:th hail intercepts all other hails x-postion
    # Thus a rock that starts at the x-postion of hail 92, with the same speed, will hit
    # all others hails x-postions, at times T as computed below.
    # If that is the valid x-solution then we can compute also y and z.
    x0 = p[92, 1]
    vx = v[92, 1]
    T = []
    for i ∈ 1:hails
        vx == v[i,1] ?
            push!(T, 0) :
            push!(T, (p[i,1] - x0) ÷ (vx - v[i,1]))
    end
    p_hit = p .+ v .* [T T T]
    vy = (p_hit[2,2] - p_hit[1,2]) ÷ (T[2] - T[1])
    y0 = p_hit[3, 2] - vy * T[3]

    vz = (p_hit[2,3] - p_hit[1,3]) ÷ (T[2] - T[1])
    z0 = p_hit[1,3] - vz * T[1]
    
    println("Part 2: ", sum([x0, y0, z0])) 

    #= This is the code that discovered hail 92 (and solves the example).
    p2 = 0
    for first ∈ 1:hails
        for t_first ∈ 0:3 #287200330416098:297200330418098
            pstone = [typemax(Int), typemax(Int), typemax(Int)]
            for dim ∈ 1:3
                for vs ∈ -1000:1000
                    ps = p[first, dim] + t_first*(v[first, dim] - vs)
                    found = true
                    for test ∈ 1:hails
                        test==first && continue
                        if v[test, dim]==vs && p[test, dim]==ps
                            continue
                        end
                        if v[test, dim]==vs || (ps - p[test, dim]) % (v[test, dim] - vs) ≠ 0  ||
                                 (ps - p[test, dim]) ÷ (v[test, dim] - vs) ≤ t_first

                            found = false
                            break
                        end
                    end
                    if found
                        pstone[dim] = ps
                        println("dim: $dim, ps: $ps, vs: $vs")
                        break
                    end
                end
            end
            if all(pstone .≠ typemax(Int))
                p2 = sum(pstone)
                println("Found: ", p2)
            end
        end
    end
    =#
end