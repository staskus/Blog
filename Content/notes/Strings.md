---
title: String manipulation
excerpt: Algorithms
---

## Example problem

### Longest Substring Without Repeating Characters

The **sliding window** approach is most intuitive. We should aim for O(n) time complexity and constant space complexity if the charset is made only from ASCII characters. 

1. Remember used letters
2. When the right side of the window encounters the letter that is already used, move the left side of the window to the position after the first occurrence of that letter
3. The longest substring is the largest distance between the left and the right side of the windows

### Longest Repeating Character Replacement

What is the longest substring with repeating letters, allowing *k* replacements.

To solve the problem we need to think about *k* replacements as *allowed mistakes* inside a string. 

We can use the same **sliding window** approach. However, we increase *start index* when there are more mistakes than allowed.

```swift
func characterReplacement(_ s: String, _ k: Int) -> Int {
    var startIndex = 0
    var letters = Array(s)
    var letterCount = Array(repeating: 0, count: 26)
    var longestSubstring = 0
    var maxCount = 0
            
    for (index, letter) in letters.enumerated() {    
        maxCount = max(maxCount, (letterCount[position(for: letter)] + 1))
        letterCount[position(for: letter)] += 1
        
        while mistakes(from: startIndex, to: index, max: maxCount) > k {
            letterCount[position(for: letters[startIndex])] -= 1
            startIndex += 1
        }
                    
        longestSubstring = max(longestSubstring, index - startIndex + 1)
    }
    
    return longestSubstring
}

private func mistakes(from startIndex: Int, to endIndex: Int, max: Int) -> Int {
    return endIndex - startIndex + 1 - max
}
    
private func position(for letter: Character) -> Int {
    return Int(letter.asciiValue! - Character("A").asciiValue!)
}
```