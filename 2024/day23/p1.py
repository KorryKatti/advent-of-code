from collections import defaultdict

with open("input.txt", "r") as file:
    connections = file.read().splitlines()

graph = defaultdict(set)

for connection in connections:
    a, b = connection.split("-")
    graph[a].add(b)
    graph[b].add(a)

triangles = set()

for a in graph:
    for b in graph[a]:
        for c in graph[b]:
            if c in graph[a] and a != b and b != c and a != c:
                triangles.add(tuple(sorted([a, b, c])))

result = [t for t in triangles if any(node.startswith("t") for node in t)]

print(len(result))