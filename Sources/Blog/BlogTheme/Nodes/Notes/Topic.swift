import Publish
import Foundation

struct Topic {
    let name: String
    var items: [Item<Blog>]
}

extension Topic {
    static func group(items: [Item<Blog>]) -> [Topic] {
        var topicsByName: [String: Topic] = [:]

        for item in items {
            let topicIdentifier =  item.metadata.topic.lowercased()
            if topicsByName[topicIdentifier] == nil {
                topicsByName[topicIdentifier] = Topic(name: item.metadata.topic, items: [item])
            } else {
                topicsByName[topicIdentifier]!.items.append(item)
            }
        }

        return topicsByName
            .map { $1 }
            .sorted { $0.name < $1.name }
    } 
}