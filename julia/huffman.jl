import DataStructures: BinaryMinHeap, nil, cons

const NULLCHAR = '\x7f'

mutable struct Node
    freq::Int
    c::Char
    left::Union{Node,Nothing}
    right::Union{Node,Nothing}
end

Base.isless(a::Node, b::Node) = a.freq < b.freq

function compute_code_tree(s::String)::Union{Node,Nothing}
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

    if length(h) == 0
        nothing
    else
        pop!(h)
    end
end

function compute_code_table(decoder::Union{Node,Nothing})::Dict{Char,String}
    r = Dict{Char,String}()

    visit = (n::Node, p::LinkedList{Char}) => 
        if n.c != NULLCHAR
            r[n.c] = join(p, "")
        end

        dfs(t, visit, Nil{Char}())
    r
end



s = "foo bar baz bee"
decoder = compute_code_tree(s)
println(decoder)
