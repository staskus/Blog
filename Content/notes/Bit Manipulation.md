---
title: Bit Manipulation
excerpt: Operations
---

```
X ^ 0s = X 
X & 0s = 0 
X | 0s = X 

X ^ 1s = !x 
X & 1s = X 
X | 1s = 1s 

X ^ X = 0 
X & X = X 
X | X = X
```

**Logical Shift** - we shift the bits and put 0 in the most significant bit.
**Arithmetic Shift** - we shift values to the right but fill new bits with the values of the sign bit. Essentially meaning division by 2.

## Example Tasks

### Get Bit

```swift
func getBit(num: Int, position: Int) -> Bool {
    return (num & (1 << position)) != 0
}

getBit(num: 5, position: 2) // 0101 & 0100 = 0100 != 0
getBit(num: 5, position: 1) // 0101 & 0010 = 0000 == 0
```

### What does code (n & n-1) == 0 do?

This logic checks if n is a power of 2 (or if n is 0)

### Write a function to determine the number of bits you need to flip to convert integer A to integer B

```swift
func bitSwapsRequired(_ a: Int, _ b: Int) -> Int {
    var count = 0

    var i = a ^ b

    while i != 0 {
        count += 1
        i = i & (i - 1)
    }

    return count
}

print(bitSwapsRequired(29, 15)) // 2
```