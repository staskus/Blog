import Foundation
import Publish
import Plot
import SplashPublishPlugin

try Blog().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .blog),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap(),
    .deploy(using: .gitHub("staskus/staskus.github.io")),
])

