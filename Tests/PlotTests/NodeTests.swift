/**
*  Plot
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import XCTest
import Plot

final class NodeTests: XCTestCase {
    func testEscapingText() {
        let node = Node<Any>.text("Hello & welcome to <Plot>!;")
        XCTAssertEqual(node.render(), "Hello &amp; welcome to &lt;Plot&gt;!;")
    }

    func testEscapingDoubleAmpersands() {
        let node = Node<Any>.text("&&")
        XCTAssertEqual(node.render(), "&amp;&amp;")
    }

    func testEscapingAmpersandFollowedByComparisonSymbols() {
        let node = Node<Any>.text("&< &>")
        XCTAssertEqual(node.render(), "&amp;&lt; &amp;&gt;")
    }

    func testNotDoubleEscapingText() {
        let node = Node<Any>.text("Hello &amp; welcome&#160;to &lt;Plot&gt;!&text")
        XCTAssertEqual(node.render(), "Hello &amp; welcome&#160;to &lt;Plot&gt;!&amp;text")
    }

    func testNotEscapingRawString() {
        let node = Node<Any>.raw("Hello & welcome to <Plot>!")
        XCTAssertEqual(node.render(), "Hello & welcome to <Plot>!")
    }
    
    func testRawFile() {
        let node = Node<Any>.rawFile("TestResources/test.html", .utf8)
        XCTAssertEqual(node.render(), #"<div class="foo" />"#)
    }

    func testGroup() {
        let node = Node<Any>.group(.text("Hello"), .text("World"))
        XCTAssertEqual(node.render(), "HelloWorld")
    }

    func testCustomElement() {
        let node = Node<Any>.element(named: "custom")
        XCTAssertEqual(node.render(), "<custom></custom>")
    }

    func testCustomAttribute() {
        let node = Node<Any>.attribute(named: "key", value: "value")
        XCTAssertEqual(node.render(), #"key="value""#)
    }

    func testCustomElementWithCustomAttribute() {
        let node = Node<Any>.element(named: "custom", attributes: [
            Attribute(name: "key", value: "value")
        ])

        XCTAssertEqual(node.render(), #"<custom key="value"></custom>"#)
    }

    func testCustomElementWithCustomAttributeWithSpecificContext() {
        let node = Node<Any>.element(named: "custom", attributes: [
            Attribute<String>(name: "key", value: "value")
        ])

        XCTAssertEqual(node.render(), #"<custom key="value"></custom>"#)
    }

    func testCustomSelfClosedElementWithCustomAttribute() {
        let node = Node<Any>.selfClosedElement(named: "custom", attributes: [
            Attribute(name: "key", value: "value")
        ])

        XCTAssertEqual(node.render(), #"<custom key="value"/>"#)
    }
}

extension NodeTests {
    static var allTests: Linux.TestList<NodeTests> {
        [
            ("testEscapingText", testEscapingText),
            ("testEscapingDoubleAmpersands", testEscapingDoubleAmpersands),
            ("testEscapingAmpersandFollowedByComparisonSymbols", testEscapingAmpersandFollowedByComparisonSymbols),
            ("testNotDoubleEscapingText", testNotDoubleEscapingText),
            ("testNotEscapingRawString", testNotEscapingRawString),
            ("testGroup", testGroup),
            ("testCustomElement", testCustomElement),
            ("testCustomAttribute", testCustomAttribute),
            ("testCustomElementWithCustomAttribute", testCustomElementWithCustomAttribute),
            ("testCustomElementWithCustomAttributeWithSpecificContext", testCustomElementWithCustomAttributeWithSpecificContext),
            ("testCustomSelfClosedElementWithCustomAttribute", testCustomSelfClosedElementWithCustomAttribute)
        ]
    }
}
