from collections import defaultdict

with open("input.txt", "r") as file:
    connections = file.read().splitlines()

graph = defaultdict(set)

for connection in connections:
    a, b = connection.split("-")
    graph[a].add(b)
    graph[b].add(a)

def find_largest_group(graph):
    def all_connected(computers):
        return all(computers[j] in graph[computers[i]] for i in range(len(computers)) for j in range(i + 1, len(computers)))

    largest_group = []
    computers = list(graph.keys())

    for i in range(1 << len(computers)):
        subset = [computers[j] for j in range(len(computers)) if i & (1 << j)]
        if all_connected(subset) and len(subset) > len(largest_group):
            largest_group = subset

    return sorted(largest_group)

largest_group = find_largest_group(graph)
password = ",".join(largest_group)
print(password)
