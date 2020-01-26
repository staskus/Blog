import Foundation
import Publish
import Plot
import SplashPublishPlugin

try Blog().publish(
    withTheme: .blog,
    plugins: [.splash(withClassPrefix: "")]
)
