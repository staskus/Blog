---
title: Linked Lists
excerpt: Data Structures
---

In a linked list, each node points to the next node in the linked list. In a doubly-linked-list, each node also points to the previous node. 

The benefit of a linked list is that items are added and removed in constant time.

## The Runner Technique

Iterate through the linked list with two pointers simultaneously, one going faster than the other. 

## Recursion

Many linked list problems are solved with recursion. The only caveat is that it takes at least O(n) space. 


## Example tasks to know how to solve:

### Remove nth element from the end

We could use the 2 runner technique to solve this issue. We can have one pointer always nth the elements behind it. When the first pointer reaches the end, we have a second pointer point to the nth element from the end that we need to remove.

### Partition a linked list by value

It could be done by creating 2 linked lists one with values larger than the given value and the other one with smaller values and in the end, merging those lists. 

### Check if singly-linked-list values construct a palindrome

To do this in place with O(1) space complexity we need to work directly on the list.

- Using the runner technique: fast and slow pointers. When the fast reaches the end, the slow reaches the middle
- Reverse the linked list from the middle
- Compare values one by one, from the start and the middle

### Find the intersection of two linked lists

- A medium solution would be to put nodes into a hashtable and compare
- The best solution is to calculate the lengths of two linked lists and then compare the nodes at the same starting point

Here's a clever way to find an intersection. The trick is to set the value of one of the current nodes to the head of the other list when the end is reached:

```swift
    func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? { 
        var currentA = headA
        var currentB = headB
        
        while currentA !== currentB {
            currentA = currentA == nil ? headB : currentA?.next
            currentB = currentB == nil ? headA : currentB?.next
        }
        
        return currentA
    }
```

### Detecting a loop in a linked list

- A medium solution putting nodes into a hashtable (set). Have in mind that in Swift nodes have to be `Hashable` or simply wrapped in the `ObjectIdentifier` so we would compare references
- The best solution is to detect a loop using the runner technique. If there's a loop, they will eventually meet. The harder part to understand is finding **the start of the loop**. It will be exactly between the *head* and the *collision* point. Therefore going step by step from the *head* and the *collision* the next collision will happen at *the start of the loop*.

```swift
  func colissionNode(_ head: ListNode?) -> ListNode? {
        var slow = head
        var fast = head
        
        while fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            
            if slow === fast {
                return slow
            }
        }
        
        return nil
    }
```

If we do the math we can see that F = b, therefore going step by step from the start and from the point h we will reach the start of the loop:
![LeetCode.com](/images/notes/67ea9a4463080be07ce89fc92ba437d53482bdce56217f6ff1ffe17e021bf200.png)  

### Merge two sorted lists

We can do that recursively and iteratively. By doing it iteratively we save space and have constant space complexity. 

The algorithm relies on 3 concepts:
- Creating a prehead, that we use as a beginning of our merged list
- Keeping the previous pointer, that allows merging step by step
- In the end, connect to a non-merged part of a list. It can happen when lists are not of the same size.

```swift
// Time Complexity O(n+m)
// Space Complexity O(1)
func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    guard let list1 = list1 else { return list2 }
    guard let list2 = list2 else { return list1 }
    
    var list1Ptr: ListNode? = list1
    var list2Ptr: ListNode? = list2
    var previousPtr: ListNode?
    var prehead: ListNode? = ListNode(-1)
    
    previousPtr = prehead
    
    while list1Ptr != nil, list2Ptr != nil {            
        if list1Ptr!.val <= list2Ptr!.val {
            previousPtr?.next = list1Ptr
            list1Ptr = list1Ptr?.next
        } else {
            previousPtr?.next = list2Ptr
            list2Ptr = list2Ptr?.next
        }
        
        previousPtr = previousPtr?.next
    }
    
    previousPtr?.next = list1Ptr == nil ? list2Ptr : list1Ptr
    
    return prehead?.next
}
```