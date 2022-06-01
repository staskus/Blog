---
title: Audio & Video
excerpt: iOS
---

AVFoundation uses the AVAsset class to progressively download from a remote host, and stream-based media that a host serves using *HTTP Live Streaming*. 

AVFoundation is a wrapper around CoreAudio, CoreMedia, CoreVideo and CoreAnimation.

Main features:
1. Inspect
2. Playback
3. Export
4. Capture
5. Compose

## Loading

`AVAsset` models the static aspects of a media resource. Creating an `AVAsset` does not load the resource, media is not loaded until prompted. 

Asset inspection is also an asynchronous process. We only get what we ask for.

We load values by providing keys to a loading method:

```swift
let url: URL = // A URL to a local or remote media resource.
let asset = AVAsset(url: url)
// Load the value of the asset's duration property asynchronously.
asset.loadValuesAsynchronously(forKeys: ["duration"]) {
    var error: NSError?
    if asset.statusOfValue(forKey: "duration", error: &error) == .loaded {
        // Access the property value synchronously.
        presentDuration(asset.duration) // If we call asset.duration before loading, it would block I/O!
    }
}
```

Swift 5.5 way. Old way will be deprrecated. 
```swift
func inspectAsset() async throws {
    let asset = AVAsset(url: movieURL)
    let duration = try await asset.load(.duration)
    myFunction(thatUses: duration)
}

func inspectAsset() async throws {
    let asset = AVAsset(url: movieURL)
    let (duration, tracks) = try await asset.load(.duration, .tracks)
    myFunction(thatUses: duration, and: tracks)
}
```

![Apple.com](/images/notes/1bccd220960e2615c1c6b0933efea56e88b83393de2c8d325a749f8d37b9e4f6.png)  


We can export and save files using similar`exportAsynchronouslyWithCompletionHandler`.

AVFoundation distinguishes between static and dynamic aspects of media:
1. Static: AVAsset, AVAssetTrack... 
2. Dynamic: AVplayerItem, AVPlayerItemTrack...

## Media Playback with AVKit

`AVKit` is built on top of `AVFoundation`. Allows to reuse intuitive Apple UI, with `AVPlayerViewController` and `AVRoutePickerView`.

```swift
import AVKit

let player = AVPlayer(url: "https://stream.com/video.m3u3")

let playerViewController = AVPlayerViewController()
playerViewController.player = player

present(...)
```

## Time

Time is presented by `CMTime` or `CMTimeRange` (containing start and end times).

## HTTP Live Streaming

![picture 3](/images/notes/92fd3d4ecd5caee3c6cc2980d0918499ff0b5588294b07575264314b0f8e47ca.png)  

https://developer.apple.com/streaming/

HLS consists of 3 parts:
1. Server (resposible for encoding, encapsulating in a format suitable for delivery and distribution)
2. Distribution (web-server or web-caching system that delivers media files or index files over HTTP)/
3. Client (begings by fetching the index file, using a URL that identifies the stream)

AVAssetVariant:
- Bitrate (32.91Mbps)
- Audio attributes (ec-3, channels)
- Video attributes (dvh1, resolution, fps)

HLS downloads:
- Introduced in 2016

Streaming tools:
- https://developer.apple.com/documentation/http_live_streaming/using_apple_s_http_live_streaming_hls_tools