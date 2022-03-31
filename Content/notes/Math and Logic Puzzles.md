---
title: Math and Logic Puzzles
excerpt: Algorithms
---

## Popular tasks

### Generate a list of prime numbers

```swift
// The Sieve of Eeratosthenes is a way to generate a list of primes by recognizing that all non-prime numbers are divisible by a prime number

// The idea is to cross of numbers that are divisible by the next available prime

// Example: 13

// We cross of powers of 2: 4, 6, 8, 10, 12
// Then cross of powers of 3: 9, 12
// We do that until the prime we pass is less than or equal to the square root of the max number

// We can optimize by only dealing with odd numbers

func countPrimes(_ n: Int) -> Int {
    guard n >= 2 else { return 0 }
    
    var flags: [Bool] = Array(repeating: true, count: n)
    flags[0] = false
    flags[1] = false
    
    var prime = 2
    
    while prime <= Int(Double(n).squareRoot()) {
        crossOff(flags: &flags, prime: prime)
        
        prime = getNextPrime(flags: flags, prime: prime)
    }
    
    return flags
        .filter { $0 }  
        .count
}

private func crossOff(flags: inout [Bool], prime: Int) {
    for i in stride(from: prime * prime, to: flags.count, by: prime) {
        flags[i] = false
    }
}

private func getNextPrime(flags: [Bool], prime: Int) -> Int {
    var next = prime + 1
    
    while next < flags.count && !flags[next] {
        next += 1
    }
    
    return next
}
```