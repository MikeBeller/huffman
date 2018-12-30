package main

import (
	"container/heap"
	"fmt"
)

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
		t := &Node{l.freq + r.freq, 0, l, r}
		heap.Push(h, t)
	}

	return heap.Pop(h).(*Node)
}

func main() {
	s := "foo bar baz bee"
	t := computeCodeTree(s)
	fmt.Println("vim-go", t)
}
