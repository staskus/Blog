---
title: Big O
excerpt: Algorithms
---

Big O describes the efficiency of algorithms.

## Time Complexity

## Space Complexity

Space complexity is the amount of memory required by an algorithm.

### Recursive calls

In recursive functions, each call is added to the stack and we take this space into account.

## Cases

* Best Case
* Worst Case
* Expected Case

The best case is not insightful. The expected case and the worst case are usually the same but not always. 

## Simplification

Big O is only concerned about the *rate of increase* and expressed how the runtime scales, thus we can drop the constants and non-dominant terms. O(2N) is just O(N).

* O(N$^2$ + N) is O($N^2$)
* O(N + log N) is O(N)
* O(100*2$^2$ + 5000N$^2$) is O(2$^n$)

![Complexities - GeeksForGeeks.org](/images/notes/42d971b30d15ec5efd2f8e1238e39424451afd922a0d719fa83811f80aeaf160.png) 

However, have in mind that it's usually not possible to remove *multiple variables*, they still need to be represented in the notation. 

For example, to sort an array of sorted strings the complexity would be *O($a*s$(log a + log s))*, where a - array length, s - longest string length. In such cases, we cannot simplify much further.

### O(n)

The algorithm that reverses an array only going through half of the array does not impact big O time and still has O(n) time complexity. 

### O(log N)

An algorithm will likely have an O(log N) runtime when the number of elements in the problem space gets halved at every step. Example - binary search.

### O(2$^n$)

The base of an exponential complexity matters.

### O(2$^l$$^o$$^g$$^N$)

This expression can be simplified to O(n). If we search binary tree making recursive calls the depth is roughly logN so it doesn't turn the recursive function exponential.

## Memoization

Caching previously computed values is an optimization technique called memoization. It is a very common way to optimize exponential time recursive algorithms. 

