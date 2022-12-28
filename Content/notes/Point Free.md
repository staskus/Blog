---
title: Point Free
excerpt: iOS
---

## Functions

### Pipe forward operator
    
```swift
precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
  return f(a)
}
```

### Composition

```swift
precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition
```

### Real world examples

With these two operators, we can efficiently use map and filter, without having to iterate through arrays twice,

```swift

[1, 2, 3].map(incr).map(square) // Less efficient
[1, 2, 3].map(incr >>> square) // efficient

```
