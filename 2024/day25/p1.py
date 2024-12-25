def parse_input(file_path):
    """Parse input file to separate lock and key schematics."""
    with open(file_path, 'r') as f:
        sections = f.read().strip().split("\n\n")  # Separate locks and keys by empty line

    locks = []
    keys = []

    for section in sections:
        lines = section.splitlines()
        # Determine if it's a lock or key by checking top and bottom rows
        if '#' in lines[0]:  # Lock has '#' on the top row
            locks.append(lines)
        elif '.' in lines[0]:  # Key has '.' on the top row
            keys.append(lines)

    return locks, keys


def get_heights(schematic, from_top=True):
    """Convert a schematic into a list of column heights."""
    heights = []
    rows = len(schematic)
    for col in zip(*schematic):  # Transpose to get columns
        if from_top:
            # Count '#' from the top
            heights.append(sum(1 for cell in col if cell == '#'))
        else:
            # Count '#' from the bottom
            heights.append(sum(1 for cell in reversed(col) if cell == '#'))
    return heights


def count_compatible_pairs(locks, keys):
    """Count compatible lock/key pairs."""
    lock_heights = [get_heights(lock) for lock in locks]
    key_heights = [get_heights(key, from_top=False) for key in keys]
    max_height = len(locks[0])  # Total number of rows in the schematics

    compatible_pairs = 0

    # Check each lock against each key
    for lock in lock_heights:
        for key in key_heights:
            if all(lock[i] + key[i] <= max_height for i in range(len(lock))):
                compatible_pairs += 1

    return compatible_pairs


if __name__ == "__main__":
    input_file = "input.txt"  # Ensure this file contains the schematics
    locks, keys = parse_input(input_file)
    result = count_compatible_pairs(locks, keys)
    print("Number of unique lock/key pairs that fit:", result)
