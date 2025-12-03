input = open("input.txt")

lists_of_lists = [line.strip().split() for line in input]

def largest_two_digit(lst):
    line = lst[0]
    digits = [int(d) for d in line]
    max_val = 0
    for i in range(len(digits) - 1):
        val = digits[i] * 10 + max(digits[i+1:])
        if val > max_val:
            max_val = val
    return max_val

def largest_k_digit(lst, k=12):
    line = lst[0]
    digits = [int(d) for d in line]
    n = len(digits)
    
    result_digits = []
    start = 0
    for i in range(k):
        remaining = k - i - 1
        end = n - remaining

        max_pos = start
        for pos in range(start + 1, end):
            if digits[pos] > digits[max_pos]:
                max_pos = pos
        
        result_digits.append(digits[max_pos])
        start = max_pos + 1
    
    result = 0
    for digit in result_digits:
        result = result * 10 + digit
    
    return result

# Part 1
result1 = sum(map(largest_two_digit, lists_of_lists))
print(result1)

# Part 2
result2 = sum(map(largest_k_digit, lists_of_lists))
print(result2)
