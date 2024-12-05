"""
# Open the data file
with open('data.txt', 'r') as file:
    lines = file.readlines()

# Separate columns
column1 = [line.split()[0] for line in lines]
column2 = [line.split()[1] for line in lines]

# Save each column to separate files
with open('column1.txt', 'w') as col1_file:
    col1_file.write('\n'.join(column1))

with open('column2.txt', 'w') as col2_file:
    col2_file.write('\n'.join(column2))



# Sort and save a column from a file
def sort_and_save(input_file, output_file):
    with open(input_file, 'r') as file:
        data = file.readlines()


    sorted_data = sorted(data, key=lambda x: int(x.strip()))

    with open(output_file, 'w') as file:
        file.writelines(sorted_data)

sort_and_save('column1.txt', 'sorted_column1.txt')


sort_and_save('column2.txt', 'sorted_column2.txt')




# Read the numbers from both files
with open('sorted_column1.txt', 'r') as col1_file:
    column1 = [int(line.strip()) for line in col1_file.readlines()]

with open('sorted_column2.txt', 'r') as col2_file:
    column2 = [int(line.strip()) for line in col2_file.readlines()]

# Ensure both columns have the same length
if len(column1) != len(column2):
    raise ValueError("The files do not have the same number of rows!")

# Calculate the absolute difference for each row
differences = [abs(a - b) for a, b in zip(column1, column2)]

# Save the results to a file
with open('differences.txt', 'w') as diff_file:
    diff_file.write('\n'.join(map(str, differences)))

# Read the differences from the file
with open('differences.txt', 'r') as diff_file:
    differences = [int(line.strip()) for line in diff_file.readlines()]

# Calculate the total sum
total_sum = sum(differences)

# Save the result to a new file
with open('total_sum.txt', 'w') as sum_file:
    sum_file.write(str(total_sum))

# Read the data from the file
with open('data.txt', 'r') as file:
    data = [line.strip().split() for line in file.readlines()]

# Split the data into two columns (left and right)
left_list = [int(pair[0]) for pair in data]
right_list = [int(pair[1]) for pair in data]

# Sort both lists
left_list.sort()
right_list.sort()

# Calculate the total distance by summing the absolute differences
total_distance = sum(abs(a - b) for a, b in zip(left_list, right_list))

# Save the total distance to a file
with open('total_distance.txt', 'w') as output_file:
    output_file.write(str(total_distance))
"""

# -------------------------------------------------------------------------------------------------------------------

# Step 1: Read data from the file
with open('data.txt', 'r') as file:
    # Read all lines, strip extra spaces, and split them into pairs
    data = [line.strip().split() for line in file.readlines()]

# Step 2: Separate data into two lists
# Convert the first column into left_list (numbers from column 1)
left_list = [int(pair[0]) for pair in data]

# Convert the second column into right_list (numbers from column 2)
right_list = [int(pair[1]) for pair in data]

# Step 3: Count occurrences in right_list
# Create an empty dictionary to store counts
right_count = {}
for num in right_list:
    if num in right_count:
        right_count[num] += 1  # Increment count if the number already exists
    else:
        right_count[num] = 1  # Initialize count for a new number

# Step 4: Calculate the weighted sum for left_list
# Initialize the total weighted sum
weighted_sum = 0

# Loop through every number in the left_list
for num in left_list:
    # Look up the number in the right_count dictionary
    # If the number exists, get its count; otherwise, use 0
    occurrences = right_count.get(num, 0)

    # Multiply the number by its occurrences and add it to the total
    weighted_sum += num * occurrences

# Step 5: Write the result to a file
with open('weighted_sum.txt', 'w') as output_file:
    # Convert the weighted sum to a string and write it to the file
    output_file.write(str(weighted_sum))
