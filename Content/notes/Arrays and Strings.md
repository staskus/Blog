---
title: Array and Strings
excerpt: Data Structures
---

## Hash Tables

We can implement hash tables using the combination of arrays and linked lists. 

1. We compute hash code and % it from array length
2. At each array position there's a linked list to deal with collisions
3. When retrieving values find a linked list by a key (hash & index) and then search through a linked list for a key

Although the worst-case scenario due to collisions is 0(n), a good implementation that keeps collisions at a minimum is considered to be O(1)

## Resizable Arrays

Some programming languages have only fixed-size arrays and use different types of data structures like ArrayList which expands in size dynamically. It does this by doubling its size after reaching a limit.

## Example tasks to know how to solve:

### Two Sum

A very popular problem with a lot of variations.

#### If numbers array is already sorted

If the numbers array is already sorted, we can use 2 pointer approach, where one starts at the end and the other at the start. If they both sum to a target, we have found our solution. If our sum is smaller, we need to increase leftIndex. If our sum is larget, we need to decrease our rightIndex.

```swift
// O(n) O(1)
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var lowIndex = 0
    var highIndex = numbers.count - 1
    
    while lowIndex < highIndex {
        let sum = numbers[lowIndex] + numbers[highIndex]
        if sum == target {
            return [lowIndex, highIndex]
        } else if sum > target {
            highIndex -= 1
        } else {
            lowIndex += 1
        }
    }
    
    return []
}
```

#### If numbers array is not sorted

1. We calculate the remaining value
2. If it's already in the map, we return indices
3. Else, save the current number in the map

```swift
// O(n) O(n)
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var map: [Int: Int] = [:]
    
    for i in 0..<numbers.count {
        let remaining = target - numbers[i]
        
        if let remainingIndex = map[remaining] {
            return [remainingIndex, i]
        }
        
        map[numbers[i]] = i
    }
    
    return []
}
```

### Three Sum

Such task is a continuation of Two Sum. We should find ways to call Two Sum logic for elements in a Three Sum problem. Naturally, the time complexity grows to O(n^2).
 
 
### Determine if String has unique characters

We can use Sets or Hashmaps. If we can only use Arrays clarify the limitations of an alphabet. If it's the English alphabet we can create an array of size 26 (size 128 if including all ASCII characters) and the element's position would be *character.asciiValue - 'a'.asciiValue*.

### Given two strings decide if one is a permutation of the other

We can sort and check if they are equal with time complexity O(nlogn) and space complexity O(1).

We can use hashtables with time complexity O(n) and space complexity O(n).

If the alphabet has limitations (as explained before) we can use fixed-size arrays with a space complexity of O(1).

### Check if a string is a permutation of a palindrome

In such a task is important to nail down what exactly is a palindrome. It has no more than one odd number-letter count. We can again use fixed-size arrays to make letter counts.

### Check if 2 strings are one edit (insert, remove, replace) away

It's important to exit early from clear invalid cases. Then go through a long string and return false if found more than one difference.

### Compressing the string into its letter counts without using extra space

What is helpful is using a concept of a *read pointer* and a *write pointer*. While we make calculations going together with *read pointer*, *write pointer* can execute changes on the string without making some positioning calculations.

### Rotate Matrix without using extra space

**A very popular problem**

Having drawn examples helps with finding the patterns of how matrices work. 

2 main options for solving:
* Transpose (flip diagonally) and Reflect (left to right / top to bottom)
* Rotate squares inside a matrix (Which I choose as it uses twice as less iterations)

Each matrix has n/2 (where n is a number of elements in a row) squares. We need to iterate through all the squares and swap elements at the corners of those squares. 

![[picture 1](https://www.enjoyalgorithms.com/blog/rotate-a-matrix-by-90-degrees-in-an-anticlockwise-direction)](/images/notes/f53df9570974ef456f0347b2fe8bb8e09876c4c0c4910f51a3fb2bfb42ffc5fb.png)  

After exchanging the upper layer, we move into inner layer circles (in larger matrices)

Example of turning the matrix 90 degrees

```swift
let n = matrix.count
        for layer in 0..<n/2 {
    // Going through elements in the layer. The deeper the layer, the less the elements
    for pos in layer..<n-1-layer {
        let temp = matrix[layer][pos]
        matrix[layer][pos] = matrix[n-1-pos][layer]
        matrix[n-1-pos][layer] = matrix[n-1-layer][n-1-pos]
        matrix[n-1-layer][n-1-pos] = matrix[pos][n-1-layer]
        matrix[pos][n-1-layer] = temp
    }
}
```

### Zero Matrix

If the element is 0, its entire row and column should be zero.

In such a task optimal solution is using constant space, meaning changing matrix in place. The challenge is coming up with the flag to notify which rows and columns need to be turned to zeros. Usually, we can set flags at the beginning of rows and columns and iterate through the matrix 2 times. 

### Best Time to Buy and Sell Stock

Given the array of values, find the smallest value to buy and the largest to sell.

We can use 2 pointers approach. If the price of the left pointer is larger than a price of a right pointer, we move with the left pointer forward. Else, we calculate a possible sell price.

```swift
class Solution {
    // TimeComplexity O(n)
    // SpaceComplexity 0(1)
    func maxProfit(_ prices: [Int]) -> Int {
        // 2 pointer approach
        // If right finds smaller, left moves to the right
        
        var leftPtr = 0
        var rightPtr = 0
        var maxValue = 0
        
        while rightPtr < prices.count {
            if prices[leftPtr] >= prices[rightPtr] {
                leftPtr = rightPtr
            } else {
                maxValue = max(maxValue, prices[rightPtr] - prices[leftPtr])
            }
        
            rightPtr += 1  
        }
        
        return maxValue
    }
}
```

### Valid Palindrome

A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

"A man, a plan, a canal: Panama" is a palindrome in this case.

There are 2 main approaches:
* Filter the original, create a reverse string, compare reversed with the original (O(n), O(n))
* 2 pointer approach. One from left to right, the other from right to left, skip non-alphanumeric characters. (O(n), O(1))

``` swift
func isPalindrome(_ s: String) -> Bool {
    let letters = Array(s)
    var leftIndex = 0
    var rightIndex = letters.count - 1
    
    while leftIndex < rightIndex {
        let leftLetter = Character(letters[leftIndex].lowercased())
        let rightLetter = Character(letters[rightIndex].lowercased())
        
        if !leftLetter.isNumber && !leftLetter.isLetter {
            leftIndex += 1
            continue
        }
        
        if !rightLetter.isNumber && !rightLetter.isLetter {
            rightIndex -= 1
            continue
        }
        
        if leftLetter != rightLetter {
            return false
        }
        
        leftIndex += 1
        rightIndex -= 1
    }
    
    return true
}
```

### Maximum Subarray

Find a subarray that sums to the maximum value and return this value.

```swift
// "Dynamic Programming, Kadane's Algorithm"
// I came up on my own, no need to memorize.
// The idea is that we can dismiss "maxCandidate" if adding it to the sum is still less than the sum because it contributes negatively to the total.

// O(n), O(1)
func maxSubArray(_ nums: [Int]) -> Int {        
    var maxNum = -Int.max
    var maxCandidate = 0
    
    for num in nums {
        maxCandidate = max(num, maxCandidate + num)
        maxNum = max(maxCandidate, maxNum)  
    }
    
    return maxNum
}
```

### Find k closest(smallest, largest) points in array

Options:
1. Sorting - O(n logn), O(1)
2. Max heap - O(n + klogn), O(n)
3. Binary Search - O(n), O(n)
4. Quick Select - O(n), O(1)

We strive for O(n) time complexity, and O(1) space complexity.

Anytime we are tasked with finding the k (or kth) [smallest/largest/etc.] element(s), we should always consider whether the **QuickSelect** algorithm can be applied.

Unlike the QuickSort algorithm, the QuickSelect algorithm roughly halves the remaining elements needed to process at each iteration, so the total number of processes will average at 2N hich results in an average time complexity of O(N). The worst case is O(n^2) though. 