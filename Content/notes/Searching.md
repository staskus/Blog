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