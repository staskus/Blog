---
title: Stacks and Queues
excerpt: Algorithms 
---

## Stack

A stack has LIFO ordering. Main operations:

* pop() - remove the top element
* push(_) - add an item to the top
* peek() - look at the top element
* isEmpty() - true if there're no elements

### Usage
* Recursive algorithms

## Queue

A queue has FIFO ordering. Main operations:

* add(_) - aedd an item to the bottom
* remove() - remove the top element
* peek() - look at the top element
* isEmpty() - true if there're no elements

### Usage
* Breadth-first-search
* Implementing a cache

## Time complexity

* O(n) for accessing nth item
* O(1) for adding and removing an item

## Example tasks to know how to solve:

### Min Stack

A stack that also can get a minimum value. 

The trick here is to understand that minimum value only changes if the new smaller stack element is added. If this element is removed, we need to come back to an old minimum value. To achieve this we need to save a current min value with each *Node*. As it's a LIFO data structure we sort of have a timeline of minimum values. 

### Implement Queue using 2 Stacks

* Since the queue is FIFO and stack is LIFO we can reverse element order by moving elements from one stack to another. Doing it every push operation produces a time complexity of O(n)
* We can do an *amortized* solution with having *old* and *new* stack. Only if the *old* (reversed) element stack is empty, we shift elements from *new* to *old*. This makes the average scenario much more effective than the worst-case scenario.

### Stack supporting different types

  If the stack needs to support *popAnyType()*, *popTypeA()* and *popTypeB()* the best solution is to have separate stacks for both typeA and typeB and save a timestamp next to the nodes. When we do *popAnyType()* we can check which stack has the oldest element on top and return that.