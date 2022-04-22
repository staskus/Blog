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

    let pivotIndex = array.count + ((0 - array.count) / 2)
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

## Counting Sort

Time Complexity: O(n+k) where n is the number of elements in input array and k is the range of input. Space: O(n+k)

It can be used to sort strings where the range of characters is clearly limited.

1. Create an array representing counts of each character (ASCII / lowercase English)
2. Store a count of each character
3. Build a new string


```swift
func countingSort(_ array: [Int])-> [Int] {
    guard array.count > 0 else {return []}

    // Step 1
    // Create an array to store the count of each element
    let maxElement = array.max() ?? 0

    var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
    for element in array {
        countArray[element] += 1
    }

    // Step 2
    // Set each value to be the sum of the previous two values
    for index in 1 ..< countArray.count {
        let sum = countArray[index] + countArray[index - 1]
        countArray[index] = sum
    }

    // Step 3
    // Place the element in the final array as per the number of elements before it
    // Loop through the array in reverse to keep the stability of the new sorted array
    // (For Example: 7 is at index 3 and 6, thus in sortedArray the position of 7 at index 3 should be before 7 at index 6
    var sortedArray = [Int](repeating: 0, count: array.count)
    for index in stride(from: array.count - 1, through: 0, by: -1) {
        let element = array[index]
        countArray[element] -= 1
        sortedArray[countArray[element]] = element
    }
    return sortedArray
}
```

## Radix Sort

Time: O(kn) where k - number of passes of the sorting algorithm

This sort is usually used for integers as we iterate through each digit of the number grouping numbers by digit.

### Example Tasks

### Merge Sorted Array

Given 2 sorted arrays, merge them in place. Prerequisite: the second array is the size of the final array with preappended zeros at the end.

```swift
// O(n + m), O(1)
func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
    var p1 = m - 1
    var p2 = n - 1
    
    for p in stride(from: nums1.count - 1, through: 0, by: -1) {
        if p2 < 0 {
            break
        }
        
        if p1 >= 0, nums1[p1] > nums2[p2] {          
            nums1[p] = nums1[p1]
            p1 -= 1
        } else {
            nums1[p] = nums2[p2]
            p2 -= 1
        }
    }
}
```

## Group Anagrams

The easiest way to group array of anagrams into array of anagram arrays is to use a *hashmap* and key as sorted string. However, the time complexity is not ideal.

```swift
// Time Complexity:  O ( N K log ⁡ K ) O(NKlogK), where  N N is the length of strs, and  K K is the maximum length of a string in strs. The outer loop has complexity  O ( N ) O(N) as we iterate through each string. Then, we sort each string in  O ( K log ⁡ K ) O(KlogK) time
// O(NK)
func groupAnagrams(_ strs: [String]) -> [[String]] {
    var groupedAnagrams: [String: [String]] = [:]
    
    for string in strs {
        groupedAnagrams[String(string.sorted()), default: []].append(string)
    }
    
    return Array(groupedAnagrams.values)
}   
```

If the problem only uses only a specific set of characters (ASCII), we can create a key out of character counts. The inner loop is faster than sorting a string (K vs KlogK)

```swift
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var groupedAnagrams: [String: [String]] = [:]
        
        for string in strs {
            let characterCount = stringToCharacterCount(string)
            let key = characterCountToKey(characterCount)
            groupedAnagrams[key, default: []].append(string)
        }
        
        return Array(groupedAnagrams.values)
    }
    
    private func stringToCharacterCount(_ string: String) -> [Int] {
        var count: [Int] = Array(repeating: 0, count: 26)
        
        var characterToNumber: (Character) -> Int = {
            Int($0.asciiValue!) - Int(Character("a").asciiValue!)
        }
        
        for character in Array(string) {
            count[characterToNumber(character)] += 1
        }
        
        return count
    }
    
    private func characterCountToKey(_ characterCount: [Int]) -> String {
        var string = ""
        
        for count in characterCount {
            string += "#\(count)"
        }
        
        return string
    }
}
```

Also it's possible to use *counting sort* for an optimal solution.