//
//  Blog.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Foundation
import Publish
import Plot

struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
        case notes
        case archive
        case afterWork
         
        var name: String {
            switch self {
            case .posts: return "Posts"
            case .notes: return "Notes"
            case .archive: return "Archive"
            case .about: return "About"
            case .afterWork: return "After work"
            }
        }
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var excerpt: String
        var topic: String {
            return excerpt
        }
    }

    var url = URL(string: "https://www.staskus.io")!
    var title = "staskus.io"
    var name = "Povilas Staškus"
    var description = "Senior iOS Engineer @Automattic"
    var language: Language { .english }
    var imagePath: Path? { nil }
    var socialMediaLinks: [SocialMediaLink] { [.location, .email, .linkedIn, .github, .twitter] }
}
