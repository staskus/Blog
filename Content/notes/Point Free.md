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

With this operator, we can efficiently use map and filter, without having to iterate through arrays twice.

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

#### Backwards Composition

To work with complicated, deeply nested data structures we need a backwards composition operator. The conterintuitive fact is that setters compose backwards and there's an essential universal proof that this is the correct way these setters compose.


```swift
precedencegroup BackwardsComposition {
  associativity: left
}

infix operator <<<: BackwardsComposition

func <<< <A, B, C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
  return { x in
    g(f(x))
  }
}
```

```swift
((1, true), "Swift")
  |> (first <<< first)(incr)
// ((2, true), "Swift")
```

#### Props

Props allow to change a specific property of a struct without having to create a new instance of the struct. Swift allows to use the key path feature to access the property efficiently.

```swift
func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root)
  -> Root {

  return { update in
    { root in
      var copy = root
      copy[keyPath: kp] = update(copy[keyPath: kp])
      return copy
    }
  }
}
```

```swift
prop(\User.name)
// ((String) -> (String)) -> (User) -> User
```

## Statement vs Expression

A statement is a unit of code that performs an action. An expression is a unit of code that evaluates to a value.

```swift
// A statement example
let a = 1

// An expression exampe
let b = 1 + 1
```

## Algebraic Data Types

Algebraic data types are data structures that are built using two basic constructors: product and sum. Product constructor is used to combine two data structures into one. Sum constructor is used to combine two data structures into one, but only one of the data structures can be used at a time.

- `enum` type represents a sum type (OR, +)

An enum with 3 cases, has 1 + 1 + 1 = 3 possible states.

- `struct` type represents a product type (AND, *)

A struct with 3 bools, has 2 * 2 * 2 = 8 possible states

- `pure function` type represent an exponential type (^)

A^B = (B) -> A

We need to have these algebraic types in mind when designing our APIs. We need to make sure that we structure our code in a way so it would have the least amount of possible combinations of states thefore limiting the complexity.

### Composition without operators

#### Pipe replacement

```swift
func with<A, B>(_ a: A, _ f: (A) -> B) -> B {
  return f(a)
}

2 |> incr // Operator

with(2, incr) // Function
```

#### Forward composition replacement

```swift
func pipe<A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

2 |> incr >>> square // Operator

with(2, pipe(incr, square))) // Function
```

#### Effectful composition replacement

```swift
func chain<A, B, C>(
  _ f: @escaping (A) -> (B, [String]),
  _ g: @escaping (B) -> (C, [String])
  ) -> ((A) -> (C, [String])) {

  return { a in
    let (b, logs) = f(a)
    let (c, moreLogs) = g(b)
    return (c, logs + moreLogs)
  }
}

2 |> computeAndPrint >=> computeAndPrint // Operator

with(2, chain(computeAndPrint, computeAndPrint)) // Function
```

#### Single type composition replacement

```swift
func concat<A: AnyObject>(
  _ f1: @escaping (A) -> Void,
  _ f2: @escaping (A) -> Void,
  _ fs: ((A) -> Void)...
  )
  -> (A) -> Void {

    return { a in
      f1(a)
      f2(a)
      fs.forEach { f in f(a) }
    }
}

let filledButtonStyle = concat(
  baseButtonStyle,
  roundedButtonStyle, {
    $0.backgroundColor = .black
    $0.tintColor = .white
})
```