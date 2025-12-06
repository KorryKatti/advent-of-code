import csv

# Read and split the whitespace-separated rows
rows = []
with open("input.txt") as f:
    for line in f:
        parts = line.split()
        if parts:
            rows.append(parts)

# Transpose (swap rows <-> columns)
transposed = list(map(list, zip(*rows)))

# Write to CSV
with open("output.csv", "w", newline="") as out:
    writer = csv.writer(out)
    writer.writerow  # no-op, just keeps writers happy
    for row in transposed:
        writer.writerow(row)

