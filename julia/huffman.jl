import DataStructures: BinaryMinHeap

const NULLCHAR = '\x7f'

mutable struct Node
    freq::Int
    c::Char
    left::Union{Node,Nothing}
    right::Union{Node,Nothing}
end

Base.isless(a::Node, b::Node) = a.freq < b.freq

function compute_code_tree(s::String)::Node
    d = Dict{Char,Int}()
    for c in s
        d[c] = get(d, c, 0) + 1
    end
    nodes = Vector{Node}()
    for (fr,ch) in d
        push!(nodes, Node(fr, ch, nothing, nothing))
    end

    h = BinaryMinHeap(nodes)
    while length(h) > 1
        n1 = pop!(h)
        n2 = pop!(h)
        push!(h, Node(n1.freq + n2.freq, NULLCHAR, n1, n2))
    end

    tree = pop!(h)
    return tree
end

s = "foo bar baz bee"
decoder = compute_code_tree(s)
println(decoder)
