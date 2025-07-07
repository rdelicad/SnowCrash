import sys

argv = sys.argv[1]
res = ""

for i in range(len(argv)):
    res += chr(ord(argv[i]) - i)

print(res)