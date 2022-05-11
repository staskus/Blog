---
title: Concurrency
excerpt: iOS
---

# Grand Central Dispatch

## Serial Queues

Serial queues only have a single thread and only allow a single task to be executes at any given time.

**The main queue** is a default serial queue responsible for the UI.
When we create **DispatchQueue** it is created as serial by default unless we specify `.concurrent` in the initializer.

## Concurrent Queues

A concurrent queue, on the other hand, is able to utilize as many threads as the system has resources for. Threads will be created and released as necessary on a concurrent queue.

There are 4 global concurrency dispatch queues that we can use, so we wouldn't need to manage our own:
1. userInteractive
2. userInitiated
3. utility
4. background

## Sync vs Async

Async doesn't mean concurrent. It's possible to submit async and sync tasks to both serial and concurrent queues. 

**Sync** - queue on which the task is run must wait for the task to complete.
**Async** - queue on which the task is run doesn't need to wait for the task to complete.

*Sync and Async* describes the **source** of the task. *Serial and Concurrent* describes the **destination** of the task.

## DispatchWorkItem

Normally, we can dispatch a new task to the queue by simply using `.sync {}` or `.async {}` block calls.

However, using `DispatchWorkItem` allows to manage the task: cancel or get notified when it finishes.

```swift
let queue = DispatchQueue(label: "com.ps.app")
queue.async {
    print("With the block")
}
```

```swift
let queue = DispatchQueue(label: "com.ps.app")
let workItem = DispatchWorkItem {
    print("With the dispatch work item")
}
queue.async(execute: workItem)
```

```swift
let queue = DispatchQueue(label: "com.ps.app")
let loadImagesItem = DispatchWorkItem { }
let updateUIItem = DispatchWorkItem { }
loadImagesItem.notify(
    queue: DispatchQueue.main,
    execute: updateUIItem
)
queue.async(execute: loadImagesItem)
```

## Groups

`DispatchGroup` allows to manage a grop of tasks.

We **associate** a queue and task (block, item) with the **group**. Using `notify` block can be notified when the given task finishes.

```swift
let group = DispatchGroup()
queue1.async(group: group) { }
queue1.async(group: group) { }
queue2.async(group: group) { }

group.notify(queue: DispatchQueue.main) { [weak self] in
    print("All the work has been completed")
}
```

We can also use groups to manage different asynchronous methods using `group.enter()` and `group.leave()`. It's recommended to use `defer` call so we wouldn't forget to call `group.leave()`. 

```swift
group.enter()
loadImages {
    defer { group.leave() }
    print("Images loaded")
}

group.enter()
loadAvatars {
    defer { group.leave() }
}

// We know when both images and avatars are loaded
group.notify(..) {}
```

## Semaphores

Semaphores allows to limit the number of concurrent tasks.

3 main concepts:
- `DispatchSemaphore(value: 4)` - define number of concurrent tasks
- `.wait()` - pause execution if we have more concurrent tasks running
- `.signal()` - notify that the concurrent task is done

```swift
let semaphore = DispatchSemaphore(value: 4)

func loadImages() {
    for url in urls {
        semaphore.wait()
        loadImage(url) {
            defer { semaphore.signal() }
        }
    }
}
```

We can combine both groups and semaphores.

# Operations

We use operation when we want to reuse and combine tasks.

Operations have these states:
- isReady
- isExecuting
- isCancelled
- isFinished

We create a task by sublassing an `Operation`. We need to override `main()` method. 

If we have another task as dependency, we could take its values from `dependencies` array.

```swift
final class ImageProcessor: Operation {
  var onImageProcessed: ((UIImage?) -> Void)?

  var outputImage: UIImage?
  private let inputImage: UIImage?

  init(image: UIImage? = nil) {
    inputImage = image
    super.init()
  }

  override func main() {
    var imageToProcess: UIImage
    
    if let inputImage = inputImage {
      // We use image passed through initializer
      imageToProcess = inputImage
    } else {
      // We use image passed automatically from previous task. For example image loading task
      let dependencyImage: UIImage? = dependencies
        .compactMap { ($0 as? ImageDataProvider)?.image }
        .first
      
      if let dependencyImage = dependencyImage {
        imageToProcess = dependencyImage
      } else {
        return
      }
    }

    guard !isCancelled else { return }

    /* Long task to process image */
    
    outputImage = UIImage(cgImage: processedImage)
    
    if let onImageProcessed = onImageProcessed {
      DispatchQueue.main.async { [weak self] in
        onImageProcessed(self?.outputImage)
      }
    }
  }
}
```

## Async Operation

If we want to have async operation inside an operation we need to use such subclass:

```swift
import Foundation

class AsyncOperation: Operation {
  // Create state management
  enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      return "is\(rawValue.capitalized)"
    }
  }

  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  // Override properties
  override var isReady: Bool {
    return super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    return state == .executing
  }

  override var isFinished: Bool {
    return state == .finished
  }

  override var isAsynchronous: Bool {
    return true
  }

  // Override start
  override func start() {
    if isCancelled {
      state = .finished
      return
    }

    main()
    state = .executing
  }
}
```

and then use it by sublassing `AsyncOperation`. For example for image downloading:

```swift
final class NetworkImageOperation: AsyncOperation {
  var image: UIImage?

  private let url: URL
  private let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
  private var task: URLSessionDataTask?

  init(url: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    self.url = url
    self.completionHandler = completionHandler

    super.init()
  }

  convenience init?(string: String, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    guard let url = URL(string: string) else { return nil }
    self.init(url: url, completionHandler: completionHandler)
  }

  override func main() {
    task = URLSession.shared.dataTask(with: url) { [weak self]
      data, response, error in

      guard let self = self else { return }

      defer { self.state = .finished }

      guard !self.isCancelled else { return }

      if let completionHandler = self.completionHandler {
        completionHandler(data, response, error)
        return
      }

      guard error == nil, let data = data else { return }

      self.image = UIImage(data: data)
    }

    task?.resume()
  }

  override func cancel() {
    super.cancel()
    task?.cancel()
  }
}
```

## Dependencies between operations

We can make operations to depend on each other by using `addOperation`. We can get result from one operation inside another operation by accessing `dependencies` variable inside `main()`.

```swift
let downloadOperation = NetworkImageOperation(url: urls[indexPath.row])
let imageProcessOperation = ImageProcessOperation()
imageProcessOperation.addDependency(downloadOperation)

imageProcessOperation.onImageProcessed = { image in
    guard let cell = tableView.cellForRow(at: indexPath)
    as? PhotoCell else {
        return
    }
    
    cell.isLoading = false
    cell.display(image: image)
}

queue.addOperation(downloadOperation)
queue.addOperation(imageProcessOperation)
```

## Block Operation

A task in a block operation runs concurrently.

```swift
BlockOperation {}
```
# Problems

## Race Conditions

If multiple threads are trying write to the same shared variable we get **race conditions**.


### Serial queue

Serial queues can be used to control the access of the variable.

```swift
private let threadSafeCountQueue = DispatchQueue(label: "com.ps.app")
private var _count = 0
public var count: Int {
  get {
    return threadSafeCountQueue.sync { _count }
} set {
    threadSafeCountQueue.sync {
      _count = newValue
    }
} }
```

### Thread barrier

If getters and setters require more complex knowledge, it's recommended to use **dispatch barrier** solution instead of locks. It handles all the complexity behind a simple `.barrier` flag.

```swift
private let threadSafeCountQueue = DispatchQueue(label: "com.ps.app", attributes: .concurrent)
private var _count = 0
public var count: Int {
  get {
    return threadSafeCountQueue.sync { _count }
} set {
    threadSafeCountQueue.async(flags: .barrier) { [unowned self] in
        self._count = newValue
      }
    }
}
```

## Deadlock

When two tasks depend on each other to finish we get a **deaclock**.

On Swift deadlocks usually occur when using explicit locking mechanisms such as **semaphores** or calling **sync on the main thread**. 

# Core Data + Concurrency

`NSManagedObjectContext` is not thread safe. Use `perform` or `performAndWait` as the closure is executed on the same queue a**s the queue that created the context**.

## Saving a lot of data

On initial load of data use `performBackgroundTask`. Notice a context that is get from the closure.

```swift
persistentContainer.performBackgroundTask { context in
    for json in jsonDataFromServer {
        let obj = MyEntity(context: context)
        obj.populate(from: json)
    }
    do {
        try context.save()
    } catch {
        fatalError("Failed to save context")
  }
}
```

## Fetching data asynchronously 

Use `NSAsynchronousFetchRequest` to fetch data asynchronously. An asynchronous fetch request must be run in **a private background queue**.

## Using NSManagedObject

`NSManagedObject` cannot be shared between threads but it can be accessed from different threads using `objectId`

```swift
let objectId = someEntity.objectID
DispatchQueue.main.async { [weak self] in
  guard let self = self else { return }
  let myEntity = self.managedObjectContext.object(with: objectId)
  self.nameLabel.text = myEntity.name
}
```

## Debug issues

Use `-com.apple.CoreData.ConcurrencyDebug` flag in debug to discover Core Data concurrency issues at runtime.