---
title: String manipulation
excerpt: Algorithms
---

## Example problem

### Longest Substring Without Repeating Characters

The sliding window approach is most intuitive. We should aim for O(n) time complexity and constant space complexity if the charset is made only from ASCII characters. 

1. Remember used letters
2. When the right side of the window encounters the letter that is already used, move the left side of the window to the position after the first occurrence of that letter
3. The longest substring is the largest distance between the left and the right side of the windows