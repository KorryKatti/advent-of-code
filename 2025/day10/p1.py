from collections import deque

def solve_machine_bfs(n, button_masks, target):
    start = 0
    max_state = 1 << n
    dist = [-1] * max_state
    q = deque()
    dist[start] = 0
    q.append(start)
    
    while q:
        cur = q.popleft()
        if cur == target:
            return dist[cur]
        
        for mask in button_masks:
            nxt = cur ^ mask
            if dist[nxt] == -1:
                dist[nxt] = dist[cur] + 1
                q.append(nxt)
    
    return -1

def main():
    with open("input.txt", "r") as fin:
        total = 0
        for line in fin:
            line = line.strip()
            
            l = line.find('[')
            r = line.find(']')
            pattern = line[l + 1:r]
            n = len(pattern)
            target = 0
            for i in range(n):
                if pattern[i] == '#':
                    target |= (1 << i)
            
            # --- parse buttons ---
            button_masks = []
            i = r + 1
            while i < len(line):
                if line[i] == '(':
                    i += 1
                    mask = 0
                    while line[i] != ')':
                        if line[i].isdigit():
                            x = 0
                            while line[i].isdigit():
                                x = x * 10 + int(line[i])
                                i += 1
                            mask |= (1 << x)
                        else:
                            i += 1
                    button_masks.append(mask)
                i += 1
            
            total += solve_machine_bfs(n, button_masks, target)
        
        print(total)

if __name__ == "__main__":
    main()
