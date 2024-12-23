def process_secret(number):
    number = mix_and_prune(number, number * 64)
    number = mix_and_prune(number, number // 32)
    number = mix_and_prune(number, number * 2048)
    return number

def mix_and_prune(secret, value):
    mixed = secret ^ value
    return mixed % 16777216

def generate_nth_secret(initial_secret, n):
    current = initial_secret
    for _ in range(n):
        current = process_secret(current)
    return current

with open('input.txt', 'r') as file:
    initial_secrets = [int(line.strip()) for line in file if line.strip()]

result = sum(generate_nth_secret(secret, 2000) for secret in initial_secrets)
print(result)