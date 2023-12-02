import sys, re

# Part 1
total = 0
lines = open('input', 'r').read().splitlines()
for line in lines:
    val = re.sub('[a-z]','',line).strip()
    total += int(f'{val[0]}{val[-1]}')
print(f"Part 1: {total}")

# Part 2
digits = {"one":1,"two":2,"three":3,"four":4,"five":5,"six":6,"seven":7,"eight":8,"nine":9}
total = 0
lines = open('input', 'r').read().splitlines()
for line in lines:
    for v,i in digits.items():
        line = line.replace(v, v+str(i)+v)
    val = re.sub('[a-z]','',line)
    num = int(f'{val[0]}{val[-1]}')
    total += num
print(f"Part 2: {total}")
