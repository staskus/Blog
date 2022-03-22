import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func item(for item: Item<Blog>, on site: Blog) -> Node {
        if item.path.absoluteString.contains(Blog.SectionID.notes.rawValue) {
            return .notePage(for: item, on: site)
        } else {
            return .post(for: item, on: site)
        }
    }
}
