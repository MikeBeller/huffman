import DataStructures: BinaryMinHeap, nil, cons, LinkedList, Nil

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
    for (ch,fr) in d
        push!(nodes, Node(fr, ch, nothing, nothing))
    end

    h = BinaryMinHeap(nodes)
    while length(h) > 1
        r = pop!(h)
        l = pop!(h)
        push!(h, Node(l.freq + r.freq, NULLCHAR, l, r))
    end

    if length(h) == 0
        nothing
    else
        pop!(h)
    end
end

function dfs(t::Union{Node,Nothing}, f::Function, p::LinkedList{Char})
    if t == nothing
        return
    else
        dfs(t.left, f, cons('0', p))
        f(t, p)
        dfs(t.right, f, cons('1', p))
    end
end

function compute_code_table(tree::Union{Node,Nothing})::Dict{Char,String}
    r = Dict{Char,String}()

    visit = (n::Node, p::LinkedList{Char}) -> 
        if n.c != NULLCHAR
            r[n.c] = join(reverse(p), "")
        end

    dfs(tree, visit, Nil{Char}())
    r
end

huffman_encode(encoder, s) = join([encoder[c] for c in s], "")

function huffman_decode_char(tree::Node, bs::String)
    if tree.c != NULLCHAR
        tree.c, bs
    else
        b,bs = bs[1],bs[2:end]
        next = if b == '0' tree.left else tree.right end
        huffman_decode_char(next, bs)
    end
end

function huffman_decode(decoder::Union{Node,Nothing}, bs::String)
    if decoder == nothing
        return ""
    end
    r = Vector{Char}()
    while length(bs) > 0
        c, bs = huffman_decode_char(decoder, bs)
        push!(r, c)
    end
    join(r, "")
end

function main()
    s = "foo bar baz bee"
    decoder = compute_code_tree(s)
    encoder = compute_code_table(decoder)
    println("Encoder:", encoder)
    ed = huffman_encode(encoder, s)
    println("Encoded data: ", ed, " Len: ", length(ed))
    dd = huffman_decode(decoder, ed)
    println("Decoded data: ", dd, " Len: ", length(dd))
end

main()

