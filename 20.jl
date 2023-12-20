open("20.txt") do f
    to_rx = nothing
    broadcast = []
    flips::Dict{String, Array{Any}} = Dict()
    cons::Dict{String, Array{Any}} = Dict()
    for l ∈ eachline(f)
        name, _, outputs... = split(l, r" |, ")
        "rx" ∈ outputs && (to_rx = name[2:end])
        if startswith(l, "broadcaster")
            broadcast = split(l, r" |, ")[3:end]
        elseif startswith(l, "%")
            name, _, outputs... = split(l, r" |, ")
            flips[name[2:end]] = [false, outputs]
        elseif startswith(l, "&")
            name, _, outputs... = split(l, r" |, ")
            cons[name[2:end]] = [Dict(), outputs]
        end
    end
    for c ∈ keys(cons)
        for (from, (_, outputs)) ∈ flips
            for o ∈ outputs
                c==o && (cons[c][1][from] = false)
            end
        end
        for (from, (_, outputs)) ∈ cons
            for o ∈ outputs
                c==o && (cons[c][1][from] = false)
            end
        end
    end

    function solve()
        lows, highs = 0, 0
        cycles::Array{Int} = []
        for button ∈ Iterators.countfrom(1)
            lows += 1
            ins = [(from="broadcast", to=n, pulse=false) for n ∈ broadcast]
            while !isempty(ins)
                highs += sum([i.pulse for i ∈ ins])
                lows += sum([!i.pulse for i ∈ ins])
                filter!(s->s.to≠"rx", ins)
                outs = []
                for i ∈ ins
                    if i.to ∈ keys(flips)
                        i.pulse==true && continue
                        flips[i.to][1] = !flips[i.to][1]
                        send = flips[i.to][1]
                        append!(outs, [(from=i.to, to=n, pulse=send) for n ∈ flips[i.to][2]])
                    else
                        cons[i.to][1][i.from] = i.pulse
                        send = !all(values(cons[i.to][1]))
                        append!(outs, [(from=i.to, to=n, pulse=send) for n ∈ cons[i.to][2]])
                    end
                end
                ins = outs
                peek = filter(s->(s.to==to_rx && s.pulse), outs)
                !isempty(peek) && push!(cycles, button)
                length(cycles)==4 && return lcm(cycles)
            end
            button==1000 && println("Part 1: ", lows*highs)
        end
    end
    println("Part 2: ", solve())
end