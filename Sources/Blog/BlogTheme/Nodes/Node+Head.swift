//
//  Node+Head.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot

extension Node where Context == HTML.DocumentContext {
    static func head(for site: Blog) -> Node {
        return Node.head(
            .meta(
                .charset(.utf8),
                .name("viewport"),
                .content("width=device-width, initial-scale=1")
            ),
            .link(
                .rel(.stylesheet),
                .href("https://unpkg.com/purecss@1.0.1/build/pure-min.css"),
                .init(name: "integrity", value: "sha384-oAOxQR6DkCoMliIh8yFnu25d7Eq/PHS21PClpwjOTeU2jRSq11vu66rf90/cZr47"),
                .init(name: "crossorigin", value: "anonymous")
            ),
            .link(
                .rel(.stylesheet),
                .href("https://unpkg.com/purecss@1.0.1/build/grids-responsive-min.css")
            ),
            .link(
                .rel(.stylesheet),
                .href("/Pure/styles.css")
            ),
            .link(
                .rel(.stylesheet),
                .href("/all.css")
            )
        )
    }
}
