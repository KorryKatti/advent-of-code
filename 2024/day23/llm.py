from collections import defaultdict

# Read the list of connections from the input file
with open("input.txt", "r") as file:
    connections = file.read().splitlines()

# Create a graph using a dictionary where each key points to a set of connected vertices
# defaultdict is just a dictionary that automatically creates an empty set for new keys
graph = defaultdict(set)
vertices = set()  # Keep track of all vertices (nodes/computers) we've seen

# Build the graph from the input connections
for connection in connections:
    a, b = connection.split("-")
    graph[a].add(b)  # Add edge from a to b
    graph[b].add(a)  # Add edge from b to a (since connections go both ways)
    vertices.add(a)
    vertices.add(b)

def find_max_clique():
    # This is the Bron-Kerbosch algorithm with pivoting
    # (A fancy way of saying: "a smart method to find the largest group where everyone's connected to everyone")
    def bron_kerbosch(r, p, x, max_clique):
        # r = current group we're building
        # p = set of vertices we can still add
        # x = set of vertices we've already tried
        # max_clique = largest fully-connected group found so far (stored in a list so we can modify it in recursion)
        
        if len(p) == 0 and len(x) == 0:
            # If we can't add any more vertices and this group is bigger than our previous best,
            # update our best found group
            if len(r) > len(max_clique[0]):
                max_clique[0] = r.copy()
            return

        # Pivot selection: A trick to reduce the number of recursive calls
        # It finds the vertex connected to the most other vertices
        pivot = max((len(graph[v] & p) for v in p | x), default=0)
        pivot_vertex = next((v for v in p | x if len(graph[v] & p) == pivot), None)

        # For each possible vertex we could add...
        p_copy = p.copy()
        # The pivot optimization lets us skip vertices we know won't give us a larger group
        for v in p_copy - (graph[pivot_vertex] if pivot_vertex else set()):
            # Add this vertex to our current group
            r_new = r | {v}
            # Only keep vertices that are connected to everything in our current group
            p_new = p & graph[v]
            x_new = x & graph[v]
            # Recursively try to add more vertices
            bron_kerbosch(r_new, p_new, x_new, max_clique)
            # Move this vertex to the "already tried" set
            p.remove(v)
            x.add(v)

    # Initialize our result storage
    # We use a list containing a set so we can modify it inside the recursive function
    max_clique = [set()]
    
    # Start the search with:
    # - empty current group (set())
    # - all vertices as possible additions (vertices)
    # - no vertices in the "already tried" set (set())
    bron_kerbosch(set(), vertices, set(), max_clique)

    # Return the vertices in the largest group we found, sorted alphabetically
    return sorted(max_clique[0])

# Find the largest fully connected group and format it as required
largest_group = find_max_clique()
password = ",".join(largest_group)
print(password)