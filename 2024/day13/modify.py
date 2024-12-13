# Read the input file
with open('input.txt', 'r') as infile:
    lines = infile.readlines()

# Open the output file to write the modified data
with open('output.txt', 'w') as outfile:
    for line in lines:
        # Check if the line contains the Prize information
        if line.startswith("Prize:"):
            # Extract the X and Y values from the line
            parts = line.split(',')
            x_part = parts[0].split('=')[1].strip()
            y_part = parts[1].split('=')[1].strip()
            
            # Add 10000000000000 to both X and Y
            new_x = int(x_part) + 10000000000000
            new_y = int(y_part) + 10000000000000
            
            # Write the modified prize to the output file
            outfile.write(f"Prize: X={new_x}, Y={new_y}\n")
        else:
            # For non-Prize lines, just write them as is
            outfile.write(line)

print("Processing complete. Output saved to 'output.txt'.")
