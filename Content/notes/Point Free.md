---
title: Point Free
excerpt: iOS
---

## Functions

#### Pipe Forward

Pipe forward operator is used to chain functions together.
    
```swift
precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B>(a: A, f: (A) -> B) -> B {
  return f(a)
}
```

#### Forward Composition

Forward composition operator is used to compose two functions together into one function with the same input and output types.

```swift
precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition
```

With this operator, we can efficiently use map and filter, without having to iterate through arrays twice,

```swift
[1, 2, 3].map(incr).map(square)
[1, 2, 3].map(incr >>> square) // More efficient
```

## Side Effects

Side effects can make code harder to reason about and produce unexpected results. One of the ways to avoid side effects is to use pure functions. Pure functions are functions that do not have any side effects and always return the same result for the same input. However, it's not always possible to write pure functions. For example, we can't write a pure function that prints to the console. What we can do is to separate the side effect from the pure function. We can do this by returning a tuple of the side effect and the pure function.

#### Effectful Composition

Effectful composition operator is used to compose two functions together into one function with the same input and output types. The difference between this operator and the forward composition operator is that this operator is used to compose two functions that return a tuple of the side effect and the pure function.

```swift
precedencegroup EffectfulComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >=>: EffectfulComposition

func >=> <A, B, C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])
  ) -> (A) -> (C, [String]) {

  return { a in
    let (b, logs) = f(a)
    let (c, moreLogs) = g(b)
    return (c, logs + moreLogs)
  }
}
```

#### Single Type Composition

Single type composition operator is used to compose two functions together into one function with the same input and output types. The difference between this operator and the forward composition operator is that this operator is used to compose two functions that return the same type.

```swift
precedencegroup SingleTypeComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

func <> <A>(
  f: @escaping (A) -> A,
  g: @escaping (A) -> A)
  -> ((A) -> A) {

  return f >>> g
}
```