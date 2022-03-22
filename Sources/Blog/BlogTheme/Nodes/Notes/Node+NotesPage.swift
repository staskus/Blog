import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func notesPage(for page: Page, context: PublishingContext<Blog>) -> Node {
        return .pageContent(
            .h2(
                .class("post-title"),
                .text(page.title)
            ),
            .forEach(Topic.group(items: context.allItems(
                sortedBy: \.title,
                order: .ascending
            )
            .filter { $0.sectionID == .notes })) { topic in
                .div(
                    .h2(.text(topic.name)),
                    .noteList(for: topic.items, on: context.site)
                )
            }
        )
    }

    private static func noteList(for items: [Item<Blog>], on site: Blog) -> Node {
        return .div(
            .forEach(items) { item in
                .noteItem(for: item, on: site)
            }
        )
    }

    private static func noteItem(for item: Item<Blog>, on _: Blog) -> Node {
        return .section(
            .ul(
                .li(
                    .a(
                        .href(item.path),
                        .text(item.title)
                    )
                )
            )
        )
    }
}
