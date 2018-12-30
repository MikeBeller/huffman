package main

import (
	"container/heap"
	"fmt"
)

const NULLCHAR = 0x07f

type Node struct {
	freq  float64
	c     rune
	left  *Node
	right *Node
}

func (n Node) String() string {
	if n.c != 0 {
		return fmt.Sprintf("{%.02f %c}", n.freq, n.c)
	} else {
		return fmt.Sprintf("{%.02f %v %v}", n.freq, n.left.String(), n.right.String())
	}
}

type NodeHeap []*Node

func (n NodeHeap) Len() int { return len(n) }
func (n NodeHeap) Less(i, j int) bool {
	return n[i].freq < n[j].freq
}
func (n NodeHeap) Swap(i, j int) {
	n[i], n[j] = n[j], n[i]
}

func (n *NodeHeap) Push(v interface{}) {
	*n = append(*n, v.(*Node))
}

func (n *NodeHeap) Pop() interface{} {
	l := len(*n)
	v := (*n)[l-1]
	*n = (*n)[:l-1]
	return v
}

func computeCodeTree(s string) *Node {
	count := make(map[rune]int)
	for _, c := range s {
		count[c]++
	}

	h := &NodeHeap{}
	for k, v := range count {
		heap.Push(h, &Node{freq: float64(v) / float64(len(s)), c: k})
	}

	if len(*h) == 0 {
		panic("empty queue")
	}

	for len(*h) > 1 {
		r := heap.Pop(h).(*Node)
		l := heap.Pop(h).(*Node)
		t := &Node{l.freq + r.freq, NULLCHAR, l, r}
		heap.Push(h, t)
	}

	return heap.Pop(h).(*Node)
}

func copyAppend(a []rune, v rune) []rune {
	b := append([]rune(nil), a...)
	return append(b, v)
}

func dfs(t *Node, f func(*Node, []rune), p []rune) {
	if t == nil {
		return
	} else {
		dfs(t.left, f, copyAppend(p, '0'))
		f(t, p)
		dfs(t.right, f, copyAppend(p, '1'))
	}
}

func computeCodeTable(t *Node) map[rune]string {
	r := make(map[rune]string)

	visit := func(n *Node, p []rune) {
		if n.c != NULLCHAR {
			r[n.c] = string(p)
		}
	}

	dfs(t, visit, []rune{})
	return r
}

func huffmanEncode(encoder map[rune]string, s string) string {
	r := []rune{}
	for _, c := range s {
		r = append(r, []rune(encoder[c])...)
	}
	return string(r)
}

func decodeChar(t *Node, bs string) (rune, string) {
	if t.c != NULLCHAR {
		return t.c, bs
	} else {
		if bs[0] == '0' {
			return decodeChar(t.left, bs[1:])
		} else {
			return decodeChar(t.right, bs[1:])
		}
	}
}

func huffmanDecode(decoder *Node, bs string) string {
	r := []rune{}
	for len(bs) != 0 {
		var c rune
		c, bs = decodeChar(decoder, bs)
		r = append(r, c)
	}
	return string(r)
}

func main() {
	input := "foo bar baz bee"
	decoder := computeCodeTree(input)
	encoder := computeCodeTable(decoder)
	fmt.Println("encoder:", encoder)
	encodedData := huffmanEncode(encoder, input)
	fmt.Println("encoded data:", encodedData, "len:", len(encodedData))
	decodedData := huffmanDecode(decoder, encodedData)
	fmt.Println("decoded data:", decodedData, "len:", len(decodedData)*8)
}
