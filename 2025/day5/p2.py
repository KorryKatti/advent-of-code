def main():
    fin = open("input.txt", "r")

    one = []
    two = []
    innit = False

    for line in fin:
        line = line.rstrip('\n')
        if line == "":
            innit = True
            continue
        if not innit:
            one.append(line)
        else:
            two.append(line)

    ranges = []
    for s in one:
        L = 0
        R = 0
        dash = False
        for c in s:
            if c == '-':
                dash = True
                continue
            if not dash:
                L = L * 10 + (ord(c) - ord('0'))
            else:
                R = R * 10 + (ord(c) - ord('0'))
        ranges.append((L, R))

    ranges.sort()
    merged = []

    for L, R in ranges:
        if not merged:
            merged.append([L, R])
            continue

        lastL, lastR = merged[-1]
        if L <= lastR + 1:
            merged[-1][1] = max(lastR, R)
        else:
            merged.append([L, R])

    total_fresh = 0
    for L, R in merged:
        total_fresh += (R - L + 1)

    print(total_fresh)


if __name__ == "__main__":
    main()

