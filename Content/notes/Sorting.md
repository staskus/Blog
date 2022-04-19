---
title: Sorting
excerpt: Algorithms
---

# Sorting Algorithms

## Bubble Sort

Time: O(n$^2$), Memory: O(1)

1. Go through the array
2. Swap 2 elements
3. Continue until the array is sorted


## Selection Sort

Time: O(n$^2$), Memory O(1)

1. Look through the array
2. Find the smallest element and move it to the front
3. Repeat

## Insertion Sort

Insertion sort is fast if the array is already sorted or the dataset is really small.

Time: O(n$^2$)

```swift
// http://raywenderlich.github.io/swift-algorithm-club/Insertion%20Sort/

func insertionSort(_ array: [Int]) -> [Int] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && temp < a[y - 1] {
      a[y] = a[y - 1]                // 1
      y -= 1
    }
    a[y] = temp                      // 2
  }
  return a
}
```

## Merge Sort

Time: O(n log(n)), Memory: O(n)

1. Divide the array in half until the array is the size of 1
2. Merge them back together in a sorted way

Merge sort is more efficient and works faster than quicksort in the case of larger array sizes or datasets.

![De-Coding Technical Interview Process - Emma Bostian](/images/notes/7e695531912858f96e685ace9f097d2692be7ebcd2c4e9808388f7a07f171669.png)

```swift
func mergeSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else { return array }
    
    let middleIndex = array.count / 2

    let leftSide = mergeSort(Array(array[0..<middleIndex]))
    let rightSide = mergeSort(Array(array[middleIndex...]))

    return merge(leftSide, rightSide)
}

func merge(_ leftArray: [Int], _ rightArray: [Int]) -> [Int] {
    var leftIndex = 0
    var rightIndex = 0

    var orderedArray: [Int] = []

    // Append one by one in a sorted way
    // Because we start merging from one element arrays, we are guaranteed that elements will be sorted

    while leftIndex < leftArray.count && rightIndex < rightArray.count {
        if leftArray[leftIndex] < rightArray[rightIndex] {
            orderedArray.append(leftArray[leftIndex])
            leftIndex += 1
        } else if leftArray[leftIndex] > rightArray[rightIndex] {
            orderedArray.append(rightArray[rightIndex])
            rightIndex += 1
        } else {
            orderedArray.append(leftArray[leftIndex])
            leftIndex += 1
            orderedArray.append(rightArray[rightIndex])
            rightIndex += 1
        }
    }

    // If the left is larger, add the remaining left array elements

    while leftIndex < leftArray.count {
        orderedArray.append(leftArray[leftIndex])
        leftIndex += 1
    }

    // If the right is larger, add the remaining right array elements

    while rightIndex < rightArray.count {
        orderedArray.append(rightArray[rightIndex])
        rightIndex += 1
    }

    return orderedArray
}
```

## Quick Sort

Time: average - O(n log(n)), worst - O(n$^2$). Memory: O(log(n))

1. Pick a random element (pivot). There're theories on which element is better to pick. Else, just pick a mid element.
2. Split an array into three parts: less than the pivot, equal to the pivot, larger than the pivot
3. Merge them back together

Quicksort is more efficient and works faster than merge sort in case of smaller array sizes or datasets.

![http://raywenderlich.github.io/swift-algorithm-club/Quicksort/](/images/notes/fa7d4a6f8a071d1f4a6f1e3e9572c148813a06ed4f917a948a40f932f719b073.png)  

![De-Coding Technical Interview Process - Emma Bostian](/images/notes/80f6b547b2282e1625e834be09bfa310ff0bb1f97819d40ace9eb9b28633f2e3.png)  

In-place:
```swift
func quickSort(_ array: inout [Int]) {
    quickSort(&array, 0, array.count - 1)
}

func quickSort(_ array: inout [Int], _ left: Int, _ right: Int) {
    let index = partition(&array, left, right)

    if left < index - 1 {
        quickSort(&array, left, index - 1)
    }

    if right > index {
        quickSort(&array, index, right)
    }
}

func partition(_ array: inout [Int], _ left: Int, _ right: Int) -> Int {
    let pivot = array[(left + right) / 2]

    var left = left
    var right = right

    while left <= right {
        while array[left] < pivot {
            left += 1
        }

        while array[right] > pivot {
            right -= 1
        }

        if left <= right {
            array.swapAt(left, right)
            left += 1
            right -= 1
        }
    }

    return left
}
```

Creating additional arrays (Easy implementation)
```swift
// Naive implementation. Creating a new array for every partition.
// Might be acceptable, better know this one than not know at all

func quickSort2(_ array: [Int]) -> [Int] {
    if array.count < 2 { return array }

    let pivotIndex = array.count / 2
    let pivot = array[pivotIndex]
    var less: [Int] = []
    var greater: [Int] = []

    for i in 0..<array.count {
        if i != pivotIndex {
            array[i] > pivot ? greater.append(array[i]) : less.append(array[i])
        }
    }

    return quickSort2(less) + [pivot] + quickSort2(greater)
}
```

## Heap Sort

Time:  O(n log(n))

## Radix Sort

Time: O(kn) where k - number of passes of the sorting algorithm

This sort is usually used for integers as we iterate through each digit of the number grouping numbers by digit.