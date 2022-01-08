### Windows 95 keygen
import random


# Generate 10 random keys
for n in range(10):
    # initial keyStart
    keyStart = 999

    # generate first three digits
    while keyStart >= 333 and keyStart % 111 == 0:
        keyStart = random.randint(0,999)

    # generate last seven digits
    keyEnd = ''
    # first six digits don't matter
    for i in range(6):
        keyEnd += str(random.randint(0,9))
        
    # append a 1 (lowest possible number)
    keyEnd += '1'
    # and convert to int
    keyEnd = int(keyEnd)

    # bring the number up to something divisible by 7
    # 8 or 9 are not allowed, but there is no need to check for that
    while int(keyEnd) % 7 != 0:
        keyEnd += 1
        
    # finally, stitch the whole key together
    print(str(keyStart).zfill(3) + '-' + str(keyEnd).zfill(7))
