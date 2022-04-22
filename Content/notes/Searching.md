---
title: Searching
excerpt: Algorithms
---

## Binary Search

In binary search, we look for an element in a sorted array by comparing x to the middle of the array. If x is less we search on the left, if x is more we search on the right. We repeat until we find the x, or there are no more partitions we can make.

```swift
func binarySearch(_ array: [Int], _ x: Int) -> Int? {
    var low = 0
    var high = array.count - 1
    var mid = 0

    while low <= high {
        mid = low + high / 2

        if array[mid] > x {
            high = mid - 1
        } else if array[mid] < {
            low = mid + 1
        } else {
            return mid
        }

        return nil
    }
}
```

## Quick Select

Time: average and best - O(n), worst - O(n^2). Space - O(1).

Used to find the k or kth smallest/largest elements. It is a deviation of a quick sort.

1. Pick a pivot (for example mid element)
2. Add smaller elements to **less** array, increase index **p** every time we find a smaller element
3. Put the pivot into **p** position
4. We will have *less* array, pivot and *greater* array
5. What we know at this point is that an element in **p** position is the pth largest value
6. If we need to find k smallest values, if k == p, all the elements in **less** array are the smallest values