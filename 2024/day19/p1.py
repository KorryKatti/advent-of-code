def read_file(file_path):
    with open(file_path) as file:
        patterns = set(line.strip() for line in file.readline().split(","))
        file.readline()
        designs = [line.strip() for line in file if line.strip()]
    return patterns, designs

def can_make_design(design, patterns, memo):
    if design == "":
        return True

    if design in memo:
        return memo[design]

    for pattern in patterns:
        if design.startswith(pattern):
            leftover = design[len(pattern):]
            if can_make_design(leftover, patterns, memo):
                memo[design] = True
                return True

    memo[design] = False
    return False

def main():
    patterns, designs = read_file("input.txt")
    memo = {}
    count = 0

    for design in designs:
        if can_make_design(design, patterns, memo):
            count += 1

    print("Possible designs:", count)

if __name__ == "__main__":
    main()
