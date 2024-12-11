import time

def evolve_stones(initial_stones, blinks, output_file="output.txt"):
    stones = initial_stones[:]
    start_time = time.time()
    
    for blink in range(blinks):
        new_stones = []
        for stone in stones:
            if stone == 0:
                new_stones.append(1)
            elif len(str(stone)) % 2 == 0:
                half = len(str(stone)) // 2
                left = int(str(stone)[:half])
                right = int(str(stone)[half:])
                new_stones.extend([left, right])
            else:
                new_stones.append(stone * 2024)
        
        stones = new_stones

        with open(output_file, "w") as f:
            f.write(f"{len(stones)}\n")
            f.write(" ".join(map(str, stones)))
        
        print(f"Blink {blink + 1}/{blinks}: {len(stones)} stones")
    
    end_time = time.time()
    total_time = end_time - start_time
    print(f"Total time taken: {total_time:.2f} seconds")
    
    return len(stones)

initial_stones = [1750884, 193, 866395, 7, 1158, 31, 35216, 0]
blinks = 75

result = evolve_stones(initial_stones, blinks)
print(f"Number of stones after {blinks} blinks: {result}")
