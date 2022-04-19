import Foundation
import Publish
import Plot
import SplashPublishPlugin

try Blog().publish(
    withTheme: .blog,
    additionalSteps: [.deploy(using: .gitHub("staskus/staskus.github.io"))],
    plugins: [.splash(withClassPrefix: "")]
)

