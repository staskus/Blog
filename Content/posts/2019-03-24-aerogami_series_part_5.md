---
title: Building a real-world iOS app (Part 5): Using Clean Swift for developing testable and scalable views
date: 2019-03-24 12:00
tags: Tutorial, iOS, Swift
excerpt: In this part of the series we'll be using Clean Swift architecture for developing new features and keeping our code testable, scalable and maintainable. 
---

When starting to develop any application it's beneficial to think early about the way code can be testable and whether it would be scalable or maintainable. Many iOS applications have suffered from what is called _Massive View Controller_ problem. By putting all the code that fetches, maps, presents and styles into one ViewController it very quickly overgrows in size and complexity. A lot of solutions where introduced to tackle this problem such as MVVM, MVVM + ReactiveCocoa or VIPER. In this application we'll be using [Clean Swift](https://clean-swift.com) approach for breaking up massive view controllers into testable and maintainable parts.

## Data Structures

### Data

`Struct` containing _raw data_.

```swift
    struct Data: Equatable {
        let regions: [Region]
        let trips: [Trip]
    }
```

### View Model

`Struct` containing _State_ (loading, error, empty, loaded) and mapped data that is used by _View Controllers_ for configuring views. 

```swift
    struct ViewModel: FeatureViewModel {
        let state: ViewState<Feed.ViewModel.Content>
        let title: String

        struct Content: FeatureContentViewModel, Equatable {
            var rows: [FeedCardViewModel]
            let availableRegions: [Feed.ViewModel.Content.Region]
            let selectedRegion: Feed.ViewModel.Content.Region?

            struct Region: Equatable {
                let id: String
                let name: String
            }

            var hasContent: Bool {
                return !rows.isEmpty
            }
        }
    }
```

### Action

`Enum` with actions that _View Controller_ can do and _Interactor_ can handle. 

```swift
    enum Action {
        case load
        case changeRegion(regionId: String?)
    }
```

### Route

`Enum` with destinations that _View Controller_ can route to. 

```swift
    enum Route: Equatable {
        case book(Trip)
    }
```

## Components 

### Interactor

Receives an action, performs work and sends raw data to presenter.

* Input - _Action_
* Output - _Data_
* Uses - _Presenter_

### Presenter

Receives raw data and maps it into _View Model_

* Input - _Data_
* Output - _View Model_

### View Controller

Receives _View Model_ and configures a view according to it. Sends actions to _Interactor_.

* Input - _View Model_
* Output - _Action_
* Uses - _Interactor_, _Router_

### Router

Receives _Route_ object from _View Controller_, that contains information about next destination, and opens next _View Controller_ using _Configurator_

* Input - _Route_
* Uses  - _Configurator_

### Configurator

Takes an input and creates configured _View Controller_ with other components.

* Input - Optional configuration data.
* Output - _View Controller_
* Creates  - _Interactor_, _Presenter_, _View Controller_, _Router_


## Feature

The group of these components is called `Feature`. [Clean Swift](https://clean-swift.com) provides with XCode templates that allow to generate all of these components together. We are using [plop templates](https://github.com/staskus/aerogami-ios/tree/master/templates/plop/Feature) for feature generation. All of this allows to avoid writing boilerplate code and concentrate on actual code of the feature.

## Feed Example

`Feed` is a main [feature](https://github.com/staskus/aerogami-ios/tree/master/TravelFeatureKit/Features/Feed) of the application. We're going to see how all of these different components is used to create a complete feature.

### Feed Interactor

`Feed Interactor` uses repositories of _Region_, _Trip_ and _Airport_ for loading data. 

`dispatch` function is an entry point of any `Interactor`. 

```swift
    func dispatch(_ action: Feed.Action) {
        switch action {
        case .load:
            contentState = .loading(data: contentState.data)
            load()
        case .changeRegion(let regionId):
            changeRegion(id: regionId)
        }
    }
```

We can see when `FeedInteractor` receives _load_ action it sets current state to _loading_ and calls `load()` method. It combines `RegionRepository` and `TripRepository`, maps it to _Data_ object and passes it to `FeedPresenter` by setting _contentState_.

```swift
    func load() {
        let selectedRegion = regionRepository.getSelectedRegion()

        Observable.combineLatest(
            self.regionRepository.getRegions(),
            self.tripRepository.getTrips(in: selectedRegion?.id)
            )
            .map { (regions, trips) -> Feed.Data in
                return Feed.Data(
                    regions: regions,
                    trips: trips,
                    selectedRegionId: selectedRegion?.id,
                    tripImages: []
                )
            }
            .subscribe(
                onNext: { data in
                    self.contentState = .loaded(data: data, error: nil)
                    self.loadImages(for: data.trips)
                },
                onError: { error in
                    self.contentState = .error(error: .loading(reason: R.string.localizable.errorGenericTitle()))
                }
            )
            .disposed(by: disposeBag)
    }
```

### Feed Presenter

[Feed Presenter](https://github.com/staskus/aerogami-ios/blob/master/TravelFeatureKit/Features/Feed/FeedPresenter.swift) essentially takes `Feed.Data` and returns `Feed.ViewModel`.

```swift
    func makeContentViewModel(content: Feed.Data) throws -> Feed.ViewModel.Content {
        return Feed.ViewModel.Content(
            rows: makeFeedCardRows(content),
            availableRegions: makeAvailableRegions(content),
            selectedRegion: makeSelectedRegion(content)
        )
    }
```

We can see that _struct_ such as `FeedCardViewModel` is fairly complicated and comprehensively describes for a table view row what needs to be displayed. It ensures that there is absolutely no business logic, mapping or formatting done in a view as it's simply sets these properties to appropriate variables. 

```swift
    private func makeFeedCardRows(_ content: Feed.Data) -> [FeedCardViewModel] {
        return getSortedTrips(content).map { trip in
            currencyFormatter.currencyCode = trip.currency
            return FeedCardViewModel(
                direction: R.string.localizable.feedBothWaysTitle(),
                trip: makeTripString(trip),
                price: formatCurrency(trip),
                dateRange: dateRange(trip),
                routeName: R.string.localizable.feedBookTitle(),
                imageUrl: makeTripImageURL(trip, content: content),
                route: Feed.Route.book(trip),
                isExpired: trip.expiresAt <= Date()
            )
        }
    }
```

### Feed View Controller

View Controller in this architecture is a very lean and clean class. It does what view _should_ do: present data, handle user actions and delegate these actions to 'interactor'. 

_display()_ lets `FeedViewController` know that the state and `Feed.ViewModel` was updated. Different views then can use parts of view model to configure themselves.

```swift
    func display() {
        guard let viewModel = viewModel?.state.viewModel else { return }

        tableView.reloadData()
        headerView.configure(with: viewModel.selectedRegion)
    }
```

`Feed.Action` is sent to `Feed.Interactor` when anything meaningful happens in `FeedViewController.` For example, loading data when view appears.

```swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        interactor.subscribe()
        interactor.dispatch(Feed.Action.load)
    }
```

`Feed.Route` is sent to `Feed.Router` when `FeedViewController` wants to transition to other view controller.

```swift
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.state.viewModel?.rows[indexPath.row] else { return }

        router.route(to: cellViewModel.route)
    }
```

### Feed Router

`FeedRouter` handles _route_ actions and opens other view controllers. It uses `BookTripConfigurator` for building `BookTripViewController`. 

```swift
class FeedRouter {

    private let bookTripConfigurator: BookTripConfigurator

    weak var viewController: FeedViewController?

    init(bookTripConfigurator: BookTripConfigurator) {
        self.bookTripConfigurator = bookTripConfigurator
    }

    func route(to route: Feed.Route) {
        switch route {
        case .book(let trip):
            let bookTripViewController = bookTripConfigurator.createViewController(trip: trip)
            bookTripViewController.modalPresentationStyle = .overCurrentContext
            bookTripViewController.modalTransitionStyle = .coverVertical
            viewController?.tabBarController?.present(bookTripViewController, animated: true, completion: nil)
        }
    }
}
```

## Usage

For understanding this flow easier we can imagine a hypothetical scenario of `Feed` feature.

1. AppDelegate uses `FeedConfigurator` and calls `createViewController()` to create `FeedViewController`
2. `FeedViewController` on `viewWillAppear` calls `interactor.dispatch(Feed.Action.load)` to trigger `load` action
3. `FeedInteractor` handles `load` action and uses `TripRepository` to load an array of `Trips` from the backend. It passes an array of `Trips` to `FeedPresenter`.
4. `FeedPresenter` takes an array of `Trips` and maps it to `FeedViewModel` by formatting and localizing text, loading images and splitting it into fields that view needs to know about.
5. `FeedViewController`'s method  `display()` is triggered and table view is loaded with new data.

Although this all may seem too much at first, it actually provides developers with huge clarity when building and maintaining the project. Moreover, all these different components have clear inputs and outputs than can be unit tested. With the growing complexity of the feature it becomes convenient to simply check `Action` to see all the different things that `ViewController` does or analyse `Presenter` to understand what kind of data is actually presented.

### Result

In these series we've seen how to build iOS application by separating it into different frameworks, loading data from API and mapping it using `Codable`, sketching UIs following Apple's guidelines and develop it all on top of _Clean_ architecture. All of these steps allow the app to be scalable, maintainable and testable.  

<img src="/images/aerogami-tutorial/part5/app_demo.gif" alt="App Demo" width="300"/>
