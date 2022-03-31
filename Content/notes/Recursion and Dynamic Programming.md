---
title: Recursion and Dynamic Programming
excerpt: Algorithms
---

Hints for problems that are good candidates for recursion:
* Compute the nth element to...
* Write code to list the first n...
* Implement a method to compute all...

Approaches:
* Bottom-Up: Start by solving the most simple case
* Top-Down: Start with more complex and think about how to split them into subproblems
* Half-and-Half: Dividing the data set in half to solve the problem and then merging together the results


Recursive problems are space-intensive and take at least O(n) of memory. The same problems can be solved iteratively although it's usually more complex.

## Example problems

### Tribonacci Number

![LeetCode.com](images/notes/b8daa97dce2af0a8feb01d20e075456e68904da809bc44e9afb26ac5a82ca17e.png)  

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


### Divide 2 integers only using addition and subtraction

This brute force solution is to do the iteration and sum divisor until we get a number larger than the dividend. This is not efficient.

The more efficient solution is to use **exponential search** which in spirit is similar to a binary search. 