---
title: Building a real-world iOS app (Part 3): Fetching and parsing data from API
date: 2019-03-18 12:00
tags: Tutorial, iOS, Swift
excerpt: In this part of the series we'll be fetching and parsing data from the backend using Alamofire and Codable.
---

In the [previous part](2019-03-17-aerogami_series_part_2) we discovered a way to separate our application into frameworks and setup the architecture of our app to support dependency injection. In this part of the series we'll be fetching and parsing data from the backend using Alamofire and Codable.

## API Client

Although in the scope of this tutorial we'll be using mocked data, the application will be completely ready to support calls to REST APIs.

### Protocol

We define our [APIClient](https://github.com/staskus/aerogami-ios/blob/master/TravelAPIKit/APIClient.swift) protocol that serves as a lean interface between data fetching classes and actual implementation.

```swift
import RxSwift

public protocol APIClient {
    func get(path: String) -> Observable<Any>
}
```

It returns `Observable<Any>` which is a part of `RxSwift`. We won't be going through the basics of `RxSwift`, so it's beneficial to take a look [official documentation](https://github.com/ReactiveX/RxSwift) before continuing.

### Implementation

The actual implementation is in [BaseAPIClient](https://github.com/staskus/aerogami-ios/blob/master/TravelAPIKit/BaseAPIClient.swift), which uses [Alamofire](https://github.com/Alamofire/Alamofire) for making HTTP requests. The only method `get(path: String)` makes `GET` request by concating given path to a base URL.

```swift
import RxAlamofire
import RxSwift

public class BaseAPIClient: APIClient {
    private let baseUrl: String

    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    public func get(path: String) -> Observable<Any> {
        return RxAlamofire
            .requestJSON(.get, "\(baseUrl)/\(path)")
            .map { $1 }
    }
}
```

### Mock

If you clone the [repository](https://github.com/staskus/aerogami-ios), it will use [MockAPIClient](https://github.com/staskus/aerogami-ios/blob/master/TravelAPIKit/BaseAPIClient.swift) which takes data from files. Because it uses the same public interface, `MockAPIClient` and `BaseAPIClient` can be interchanged depending on needs. See [ApplicationAssembly](https://github.com/staskus/aerogami-ios/blob/bd558d5962e7d97300213ad6896ff8d1f548a074/TravelApplication/Application/Assembly/ApplicationAssembly.swift) which assigns dependencies for `APIClient` interface. Depending on different configuration, it can assign any of these two. This little example perfectly illustrates the power of `dependency injection` and usage of `protocols`.

## Data

The main entity in this project is a `Trip`. It describes the origin and destination of the flight as well as price and dates.

```js
{
   "currency":"EUR",
   "created_at":1547991979887,
   "airlines":"FR",
   "departure_at":1552848000000,
   "destination":{
      "city":"Malaga",
      "country_code":"ES",
      "airport_code":"AGP"
   },
   "flight_number":4048,
   "departure":{
      "city":"Copenhagen",
      "country_code":"DK",
      "airport_code":"CPH"
   },
   "return_at":1553153100000,
   "price":72,
   "id":"c4449ff0-1cb9-11e9-b9f8-b3ba95b35000",
   "expires_at":1739200281000
}
```

[See full Trips JSON file](https://github.com/staskus/aerogami-ios/blob/master/TravelApplication/Application/Mocking/TripMock.json)

We'll define our entities inside `TravelKit` framework. They should be made public, so they could be reached inside other frameworks. We'll use excellent [Codable](https://developer.apple.com/documentation/swift/codable) type that starting from Swift 4 provides a powerful and clean way to encode and decode data.

Take a look at [Trip](https://github.com/staskus/aerogami-ios/blob/master/TravelKit/Repositories/Trip/Trip.swift) class. We don't need to define keys of each values if they match. It's possible to define what naming strategies are used during decoding or encoding process. For example, `.convertFromSnakeCase` strategy, as its name suggests, converts keys from snake case and assigns values automatically if they match.

```swift
import Foundation

public struct Trip: Codable, Equatable {
    public var id: String = ""
    public var currency: String = ""
    public var price = 0

    public var airlines = ""
    public var flightNumber = 0

    public var destination: TripLocation!
    public var departure: TripLocation!

    public var createdAt = Date()
    public var departureAt = Date()
    public var returnAt = Date()
    public var expiresAt = Date()

    public init() {}
}

public struct TripLocation: Codable, Equatable {
    public var city: String!
    public var countryCode: String!
    public var airportCode: String!

    public init() {}
}
```

After receiving `JSON` data we can define `decoder` and automatically parse values.

```swift
    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()

    let trips = try? decoder.decode([Trip].self, from: data)
```

With this simple and straightforward Codable API our data is cleanly parsed into statically typed object or array of objects after [fetching from API](https://github.com/staskus/aerogami-ios/blob/master/TravelDataKit/Repositories/Trip/Remote/APITripDataStore.swift).

## Repositories

Classes that are used to fetch data will be called repositories. In `TravelKit` we'll only define the protocols of these repositories. Our UI framework `TravelFeatureKit` will only know about `TravelKit` and protocols of repositories thus the implementations, defined in `TravelDataKit`, will be easily changeable.

Our `TripRepository` protocol defines the only way to fetch trips.

```swift
import RxSwift

public protocol TripRepository {
    func getTrips(in region: String?) -> Observable<[Trip]>
}
```

Because our UI framework will only know about this protocol, we will be able to provide different types of implementations. [TripRepository](https://github.com/staskus/aerogami-ios/blob/bd558d5962e7d97300213ad6896ff8d1f548a074/TravelDataKit/Repositories/Trip/TripRepository.swift) implementation defined in `TravelDataKit` calls the `API` to fetch data and parses it using `Coadable`. However, [FavoriteTripRepository](https://github.com/staskus/aerogami-ios/blob/bd558d5962e7d97300213ad6896ff8d1f548a074/TravelDataKit/Repositories/Trip/FavoriteTripRepository.swift) which also implements `TripRepository` interface, uses `UserDefaults` to fetch locally liked `Trips`. It allows us to generate 2 completely different screens in our app. One showing the current feed of flights fetched from the API and another of liked and locally saved trips. Here [FavoritesAssembly](https://github.com/staskus/aerogami-ios/blob/bd558d5962e7d97300213ad6896ff8d1f548a074/TravelFeatureKit/Features/Favorites/FavoritesAssembly.swift) simply injects necessary dependencies needed for _favorites_ to a `FavoriteFeed` feature.

## Design

Before continuing creating the app, we'll see how we can quickly create simple application designs using Sketch or similar tools. In the next part of the series we'll overview the approach.
