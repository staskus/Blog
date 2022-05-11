import Foundation
import Publish
import Plot
import SplashPublishPlugin

try Blog().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .installPlugin(.splash(withClassPrefix: "")),
    .generateHTML(withTheme: .blog),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("staskus/staskus.github.io")),
])

