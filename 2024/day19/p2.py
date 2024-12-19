def read_file(file_path):
    with open(file_path) as file:
        patterns = set(line.strip() for line in file.readline().split(','))
        file.readline()
        designs = [line.strip() for line in file if line.strip()]
    return patterns, designs

def find_ways(design, patterns, memo):
    if design == '':
        return 1

    if design in memo:
        return memo[design]

    ways = 0
    for pattern in patterns:
        if design.startswith(pattern):
            remaining = design[len(pattern):]
            ways += find_ways(remaining, patterns, memo)

    memo[design] = ways
    return ways

def main():
    patterns, designs = read_file('input.txt')
    memo = {}
    total = 0

    for design in designs:
        total += find_ways(design, patterns, memo)

    print("Total ways:", total)

if __name__ == "__main__":
    main()
