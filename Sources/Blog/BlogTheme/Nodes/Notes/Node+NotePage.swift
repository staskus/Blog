import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func notePage(for item: Item<Blog>, on site: Blog) -> Node {
        return .pageContent(
            .h2(
                .class("post-title"),
                .a(
                    .href(item.path),
                    .text(item.title)
                )
            ),
            .p(
                .class("post-meta"),
                .text("Last modified: " + DateFormatter.blog.string(from: item.lastModified))
            ),
            .div(
                .class("post-description"),
                .div(
                    .contentBody(item.body)
                )
            )
        )
    }
}

