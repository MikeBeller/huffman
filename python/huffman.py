from collections import defaultdict, namedtuple
from typing import Optional, DefaultDict, List, Callable, Dict, Tuple
import heapq

NULLCHAR = "\x07f"

Node = namedtuple('Node', ['freq', 'c', 'left', 'right'])

def leaf(f: float, c: str) -> Node:
    return Node(f, c, None, None)

def compute_code_tree(s: str) -> Optional[Node]:
    count : DefaultDict[str,int] = defaultdict(int)
    n = 0
    for c in s:
        count[c] += 1
        n += 1

    q : List[Node] = []
    for k, v in count.items():
        heapq.heappush(q, leaf(v / n, k))

    if len(q) == 0:
        return None

    while len(q) > 1:
        r = heapq.heappop(q)
        l = heapq.heappop(q)
        t = Node(l.freq + r.freq, NULLCHAR, l, r)
        heapq.heappush(q, t)

    return heapq.heappop(q)


def dfs(t : Optional[Node],
        f : Callable[[Optional[Node], List[str]], None],
        p : List[str]):
    if t is None:
        return
    else:
        dfs(t.left, f, p + ['0'])
        f(t, p)
        dfs(t.right, f, p + ['1'])


def compute_code_table(t : Optional[Node]) -> Dict[str,str]:
    r = {}

    def visit(n, p):
        if n.c != NULLCHAR:
            r[n.c] = "".join(p)

    dfs(t, visit, [])
    return r


def gen_huffman(s: str) -> Tuple[Dict[str,str], Optional[Node]]:
    decoder = compute_code_tree(s)
    encoder = compute_code_table(decoder)
    return encoder, decoder


def huffman_encode(encoder: Dict[str,str], s: str) -> str:
    return "".join(encoder[c] for c in s)


def decode_char(t: Node, bs: str) -> Tuple[str, str]:
    if t.c != NULLCHAR:
        return t.c, bs
    else:
        if bs[0] == '0':
            return decode_char(t.left, bs[1:])
        else:
            return decode_char(t.right, bs[1:])


def huffman_decode(decoder: Optional[Node], bs: str) -> str:
    assert decoder is not None
    r = []
    while bs:
        c, bs = decode_char(decoder, bs)
        r.append(c)
    return "".join(r)


test_data = "foo bar baz bee"
encoder, decoder = gen_huffman(test_data)

print("data:", test_data)
print("encoder:", encoder)
encoded_data = huffman_encode(encoder, test_data)
print("encoded data:", encoded_data, "bits:", len(encoded_data))
decoded_data = huffman_decode(decoder, encoded_data)
print("decoded data:", decoded_data, "bits:", len(test_data) * 8)
assert test_data == decoded_data

