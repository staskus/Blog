---
title: Building a real-world iOS app (Part 2): Separating application into frameworks
date: 2019-03-17 12:00
tags: Tutorial, iOS, Swift
excerpt: We'll continue creating an application by overviewing how to properly setup the application.
---

In this part of the series we'll overview how to properly setup the application.

# Creating Frameworks

As we talked in the [previous part](/tutorial/ios/swift/aerogami_series_part_1/), we'll begin the creation of the project by creating 3 separate frameworks inside our XCode project (`TravelKit`, `TravelDataKit`, `TravelFeatureKit`). An article on [raywenderlich.com](https://www.raywenderlich.com/5109-creating-a-framework-for-ios) has a thorough explanation of the whole process.

After creating frameworks, project navigator should look something like in the picture below.

<img src="/images/aerogami-tutorial/part2/project_frameworks.png" alt="Frameworks in the Project Navigator" width="300"/>

# Setting up CocoaPods

We'll be using [CocoaPods](https://cocoapods.org) for managing dependencies in our project. Although setting up CocoaPods is fairly straightforward, there can be some difficulties when having local frameworks involved. The configuration is defined in `Podfile` which is located in the root folder of the project.

`Podfile` will be configured in a way that is clean and clear so it would not get messy when number of dependencies in the project grow. Essentially, we'll define the reusable pods at the top of the file and group different groups of pods that can be reused for different frameworks. 

The part of `Podfile` that defines pods of `TravelKit`.

```ruby
platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

deployment_target = '11.0'

workspace 'TravelApplication.xcworkspace'

#Versions
$swinjectVersion =                    '~> 2.4'
$swiftDateVersion =                   '~> 5.0'
<...>

def shared_TravelKit_pods
    pod 'RxSwift',                    $rxSwiftVersion
    pod 'SwiftDate',                  $swiftDateVersion
end

target 'TravelKit' do
    project 'TravelKit.xcodeproj'
    platform :ios, deployment_target

    shared_TravelKit_pods

  target 'TravelKitTests' do
    project 'TravelKit.xcodeproj'
    inherit! :search_paths

    shared_testing_pods
  end
end
<...>
```

These different shared pods should be assembled and used of the actual application target.

```ruby
<...>
def shared_Apps_pods
  shared_TravelKit_pods
  <...>
end

target 'TravelApplication' do
    project 'TravelApplication.xcodeproj'
    platform :ios, deployment_target
    shared_Apps_pods
end
<...>
```

The full [Podfile](https://github.com/nitesuit/aerogami-ios/blob/master/Podfile) can be found on `GitHub` as the rest of the project.

# Dependency Injection

I prefer to think early about the way dependencies will be managed inside the application. Although dependency injection can be achieved without 3rd party libraries, for this project we'll use [Swinject](https://github.com/Swinject/Swinject) that has easy to use interfaces for managing dependencies.

Our classes will use `initializer injection` thus all the dependencies will be given through the initializer. The classes will be initialized in assemblies. Assembly is a `Swinject` class which has access to a container of already injected dependencies and provides a way to register new dependencies. 

For example, this is how the assembly of the `Feed` that displays the list of flights might looks like:

```swift
import Foundation
import Swinject
import TravelKit

public class FeedAssembly: Assembly {

    public init() {
    }

    public func assemble(container: Container) {
        container.register(FeedConfigurator.self) { r in
            FeedConfigurator(
                regionRepository: r.resolve(RegionRepository.self)!,
                tripRepository: r.resolve(TripRepository.self)!,
                airportRepository: r.resolve(AirportRepository.self)!,
                tripImageRepository: r.resolve(TripImageRepository.self)!
                )
            }
            .initCompleted { (resolver, feedConfigurator) in
                feedConfigurator.bookTripConfigurator = resolver.resolve(BookTripConfigurator.self)!
            }
            .inObjectScope(.container)
    }
}
```

Here, we inject `FeedConfigurator` class. It is essentially a factory class for the whole `Feed` feature and its view. `Swinject` automatically passes the dependencies such as `RegionRepository` or `TripRepository`. We expect these dependencies to be injected in another assembly so we can resolve it here.

Our application will have `AssemblerFactory` that will contain all the different assemblies of the application and create them during initialization process. 

```swift
import Foundation
import Swinject
import TravelFeatureKit
import TravelDataKit

class AssemblerFactory {

    func create() -> Assembler {
        let assemblies: [Assembly] = [
            ApplicationAssembly(),
            RegionRepositoryAssembly(),
            TripRepositoryAssembly(),
            AirportRepositoryAssembly(),

            MainAssembly(),
            FavoritesAssembly(),
            FeedAssembly(),
            BookTripAssembly(),
            BookURLRepositoryAssembly(affiliateId: Constants.affiliateId)
        ]

        let assembler = Assembler(assemblies)

        return assembler
    }
}
```

We use this assembly to create the first `ViewController` of the application and set it as `rootViewController`. See [ApplicationLoader](https://github.com/nitesuit/aerogami-ios/blob/master/TravelApplication/Application/ApplicationLoader.swift).

```swift
  self.assembler = AssemblerFactory().create()
  let rootConfigurator = assembler.resolver.resolve(MainConfigurator.self)!
  let rootViewController = rootConfigurator.createViewController()
  window?.rootViewController = rootViewController
  window?.makeKeyAndVisible()
```

In the following parts of the series we'll be creating classes for fetching and presenting data that will use assemblies for injecting dependencies. We'll see more closely how having proper dependency injection allows code to be more reusable, safe and testable.  
