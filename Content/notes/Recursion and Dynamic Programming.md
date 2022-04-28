---
title: Recursion and Dynamic Programming
excerpt: Algorithms
---

## Recursion

Hints for problems that are good candidates for recursion:
* Compute the nth element to...
* Write code to list the first n...
* Implement a method to compute all...

Recursive problems are space-intensive and take at least O(n) of memory. The same problems can be solved iteratively although it's usually more complex.

## Dynamic Programming

Dynamic programming is useful when trying to optimize something **given a constraint**. We can use DP when the problem can be broken into subproblems and they don't depend on each other.

1. Every DP solution involes a grid
2. The values in the grid cells are what we try to optimize
3. Each cell is a subproblem

Approaches:
* Bottom-Up: Start by solving the most simple case
* Top-Down: Start with more complex and think about how to split them into subproblems
* Half-and-Half: Dividing the data set in half to solve the problem and then merging together the results


## Example problems

### Tribonacci Number

![LeetCode.com](/images/notes/b8daa97dce2af0a8feb01d20e075456e68904da809bc44e9afb26ac5a82ca17e.png)  

Such a problem can also be solved iteratively. When we use memoization we can notice that we only need to know the last 3 numbers. Instead of saving all the numbers in the dictionary, we can only save the last 3 in the variable:

```swift
// Time - O(n), Space - 0(1)
func tribonacci(_ n: Int) -> Int {
    var memo0 = 0
    var memo1 = 1
    var memo2 = 1
    
    guard n > 0 else { return 0 }
    guard n > 2 else { return 1 }
    
    var temp = 0
    
    for i in 3...n {
        temp = memo0 + memo1 + memo2
        memo0 = memo1
        memo1 = memo2
        memo2 = temp
    }
    
    return temp
}
```

We can also save time instead of space by adding the results into an array before returning the value. This is only applicable if we know the upper bound. Let's say we know that n will be a maximum 40, then we can precompute those 40 values and whenever anyone asks for tribonacci we just return a result.

```swift
// Time - O(1), Space - O(n) 
func tribonacci(_ n: Int) -> Int {
    guard n > 0 else { return 0 }
    guard n > 2 else { return 1 }
    
    var nums: [Int] = [0, 1, 1]
    for i in 3...n {
        nums.append(nums[i-1] + nums[i-2] + nums[i-3])
    } 

    return nums[n]
}
```

### Unique Paths with Obstacles in Grid

When starting from (0,0) how many unique paths there are to reach (n-1, n-1) if the path does not encounter obstacles?

We can use the grid itself as a way to convey information. We first set values of the first column and the first row. If they aren't any obstacles the value is 1, if there're the value is 0. Then we can iterate from the rest of the grid and the value of the cell are the sum of two values from the left and the top. The result at the (n-1, n-1) is the number of unique paths.

O(M×N), O(1)

### Divide 2 integers only using addition and subtraction

This brute force solution is to do the iteration and sum divisor until we get a number larger than the dividend. This is not efficient.

The more efficient solution is to use **exponential search** which in spirit is similar to a binary search. 

### Unique permutations with duplicate input

If we are given an array of numbers with possible duplications and we need to provide all the possible permutations, we need to start by creating a frequency table of each number (character). This way if we get [1, 1, 1, 1, 1] don't crate duplicating permutations.

O(n!)

### Generate Parenthesis
 
Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

This requires a *backtracking* recursive algorithm. With this concrete issue, the hard part is the calculation of time complexity. 

It's better to know that this is a backtracking algorithm, that has generally a performance O(2^n). In this concrete scenario, we have less complexity, as we don't need to explore all the permutations of parenthesis due to the relationship of closed/opened parenthesis.

```swift
private var max = 0

func generateParenthesis(_ n: Int) -> [String] {****
    max = n
    var result: [String] = []
    backtrack(&result, 0, 0)
    return result
}

private func backtrack(_ result: inout [String],
                        _ opening: Int,
                        _ closing: Int,
                        _ current: String = "") {
                    
    if current.count == max * 2 {
        result.append(current)
        return
    }
    
    if opening < max {
        var current = current
        current.append("(")
        backtrack(&result, opening + 1, closing, current)
    }
    
    if closing < opening {
        var current = current
        current.append(")")
        backtrack(&result, opening, closing + 1, current)
    }
}
```

### Coin Change

Given the set of coins (1, 2, 5) in how many ways we can combine it to a given sum (100). 

The trick for a quick solution is this algorithm. 

We calculate the number of combinations for a given amount by adding to it already calculates combinations for x-coin amount `combinations[x] += combinations[x - coin]`.

```swift
var combinations = Array(repeating: 0, count: amount + 1)
        combinations[0] = 1 // algo requires it
        
        for coin in coins {
            if coin <= amount {
                for x in coin..<amount+1 {
                    combinations[x] += combinations[x - coin]
                }
            }
        }
        
        return combinations[amount]
```

### Coin Change

Given the array of coins, return the fewest number of coins that you need to make up that amount.

### Dynamic Programming - top down approach

Use memoization and recursion:

```swift
// Dynamic programming - top down approach
// Time: O(S*n) where S is the amount and n is denomination count
// Space complexity O(s) for memo
func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    var memo: [Int: Int] = [:]
    return coinsChange(coins, amount, &memo)
}

private func coinsChange(_ coins: [Int], _ remaining: Int, _ memo: inout [Int: Int]) -> Int {
    if remaining < 0 { return -1 }
    if remaining == 0 { return 0 }
    
    if let previouslyCalculatedCount = memo[remaining] {
        return previouslyCalculatedCount
    }
    
    var minValue = Int.max
    
    for coin in coins {
        let result = coinsChange(coins, remaining - coin, &memo)
        if result >= 0 && result < minValue {
            minValue = result + 1
        }
    }
    
    memo[remaining] = minValue == Int.max ? -1 : minValue
    return memo[remaining]!
}
```

### Dynamic Programming - Bottom up approach

The key is understanding this line `counts[currentAmount] = min(counts[currentAmount], counts[currentAmount - coins[coinIndex]] + 1)`

If we get a number not equal to max in `counts[currentAmount - coins[coinIndex]]` it means that we already calculated a minimum amount and we can just add one coin `coin[coinIndex]` .

```swift
// Dynamic programming - bottom up approach

func coinChange(_ coins: [Int], _ amount: Int) -> Int {
    guard amount > 0 else { return 0 }
    
    let max = amount + 1
    var counts: [Int] = Array(repeating: max, count: amount + 1)
    counts[0] = 0
    
    for currentAmount in 1...amount {
        for coinIndex in 0..<coins.count {
            if coins[coinIndex] <= currentAmount {
                counts[currentAmount] = min(counts[currentAmount], counts[currentAmount - coins[coinIndex]] + 1)
            }
        }
    }
    
    return counts[amount] == max ? -1 : counts[amount]
}
```

### Optimal Set Of Camping

Given list of items:
```swift
let items = [
    Item(name: "Water", weight: 3, value: 10), 
    Item(name: "Book", weight: 1, value: 3), 
    Item(name: "Food", weight: 2, value: 9),
    Item(name: "Jacket", weight: 2, value: 5), 
    Item(name: "Camera", weight: 1, value: 6), 
]
```

and a bag limit of `capacity`. Find which items to take to maximize the total value.

```swift
struct Item {
    let name: String
    let weight: Int
    let value: Int
}

func optimalSetOfItems(_ capacity: Int, _ items: [Item]) -> [Item] {

    // We need to keep both total values and all items corresponding to the total value
    // We increase the capacity by one, so we wouldn't need to handle a case where we look back at dp table
    var dpItems: [[[Item]]] = Array(repeating: Array(repeating: [], count: capacity + 1), count: items.count + 1)
    var dpValues: [[Int]] = Array(repeating: Array(repeating: 0, count: capacity + 1), count: items.count + 1)

    for itemIndex in 1...items.count {

        // A key to dynamic programming, we iterate through all capacities
        for currentCapacity in 1...capacity {
                let item = items[itemIndex - 1]

                // Skip if an item is heavier than the current capacity
                if item.weight <= currentCapacity {
                    
                    // We already know the best possible value from all the items up to [itemIndex - 1]
                    let totalPreviousValue = dpValues[itemIndex - 1][currentCapacity]

                    // Take current item value
                    // We already know the best possible value for the remaining weight. We calculated it for the previous item
                    // Sum those 2 values
                    let totalPotentialValue = dpValues[itemIndex - 1][currentCapacity - item.weight] + item.value

                    // Check if our new value is larger than the total for the previous item
                    if totalPreviousValue > totalPotentialValue {
                        // If previous value is larger, set the same value and same items
                        dpItems[itemIndex][currentCapacity] = dpItems[itemIndex - 1][currentCapacity]
                        dpValues[itemIndex][currentCapacity] =  totalPreviousValue
                    } else {
                        // Else set new set of items and the new value
                        dpItems[itemIndex][currentCapacity] = dpItems[itemIndex - 1][currentCapacity - item.weight] + [item]
                        dpValues[itemIndex][currentCapacity] = totalPotentialValue
                    }
            }
        }  
    }

    return dpItems[items.count][capacity]
}
```