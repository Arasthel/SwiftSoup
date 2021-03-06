//
//  SwifSoupTests.swift
//  SwifSoupTests
//
//  Created by Nabil Chatbi on 20/04/16.
//  Copyright © 2016 Nabil Chatbi.. All rights reserved.
//

import XCTest
import SwiftSoup

class SwifSoupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testJoin() {
        XCTAssertEqual("",StringUtil.join([""], sep: " "));
        XCTAssertEqual("one",StringUtil.join(["one"], sep: " "));
        XCTAssertEqual("one two three",StringUtil.join(["one", "two", "three"], sep: " "));
    }
    
    func testPadding() {
        XCTAssertEqual("", StringUtil.padding(0));
        XCTAssertEqual(" ", StringUtil.padding(1));
        XCTAssertEqual("  ", StringUtil.padding(2));
        XCTAssertEqual("               ", StringUtil.padding(15));
    }
    
    func testIsBlank() {
        //XCTAssertTrue(StringUtil.isBlank(nil));
        XCTAssertTrue(StringUtil.isBlank(""));
        XCTAssertTrue(StringUtil.isBlank("      "));
        XCTAssertTrue(StringUtil.isBlank("   \r\n  "));
    
        XCTAssertFalse(StringUtil.isBlank("hello"));
        XCTAssertFalse(StringUtil.isBlank("   hello   "));
    }
    
    func testIsNumeric() {
//        XCTAssertFalse(StringUtil.isNumeric(nil));
        XCTAssertFalse(StringUtil.isNumeric(" "));
        XCTAssertFalse(StringUtil.isNumeric("123 546"));
        XCTAssertFalse(StringUtil.isNumeric("hello"));
        XCTAssertFalse(StringUtil.isNumeric("123.334"));
        
        XCTAssertTrue(StringUtil.isNumeric("1"));
        XCTAssertTrue(StringUtil.isNumeric("1234"));
    }
    
    
    func testIsWhitespace() {
        XCTAssertTrue(StringUtil.isWhitespace("\t"));
        XCTAssertTrue(StringUtil.isWhitespace("\n"));
        XCTAssertTrue(StringUtil.isWhitespace("\r"));
        XCTAssertTrue(StringUtil.isWhitespace(Character.BackslashF));
        XCTAssertTrue(StringUtil.isWhitespace("\r\n"));
        XCTAssertTrue(StringUtil.isWhitespace(" "));
    
        XCTAssertFalse(StringUtil.isWhitespace("\u{00a0}"));
        XCTAssertFalse(StringUtil.isWhitespace("\u{2000}"));
        XCTAssertFalse(StringUtil.isWhitespace("\u{3000}"));
    }
    
    func testNormaliseWhiteSpace() {
        XCTAssertEqual(" ", StringUtil.normaliseWhitespace("    \r \n \r\n"));
        XCTAssertEqual(" hello there ", StringUtil.normaliseWhitespace("   hello   \r \n  there    \n"));
        XCTAssertEqual("hello", StringUtil.normaliseWhitespace("hello"));
        XCTAssertEqual("hello there", StringUtil.normaliseWhitespace("hello\nthere"));
    }

    func testNormaliseWhiteSpaceHandlesHighSurrogates()throws {
        let test71540chars = "\\u{d869}\\u{deb2}\\u{304b}\\u{309a}  1";
        let test71540charsExpectedSingleWhitespace = "\\u{d869}\\u{deb2}\\u{304b}\\u{309a} 1";
    
        XCTAssertEqual(test71540charsExpectedSingleWhitespace, StringUtil.normaliseWhitespace(test71540chars));
        let extractedText = try SwiftSoup.parse(test71540chars).text();
        XCTAssertEqual(test71540charsExpectedSingleWhitespace, extractedText);
    }
	
    func testResolvesRelativeUrls() {
        XCTAssertEqual("http://example.com/one/two?three", StringUtil.resolve("http://example.com", relUrl: "./one/two?three"));
        XCTAssertEqual("http://example.com/one/two?three", StringUtil.resolve("http://example.com?one", relUrl: "./one/two?three"));
        XCTAssertEqual("http://example.com/one/two?three#four", StringUtil.resolve("http://example.com", relUrl: "./one/two?three#four"));
        XCTAssertEqual("https://example.com/one", StringUtil.resolve("http://example.com/", relUrl: "https://example.com/one"));
        XCTAssertEqual("http://example.com/one/two.html", StringUtil.resolve("http://example.com/two/", relUrl: "../one/two.html"));
        XCTAssertEqual("https://example2.com/one", StringUtil.resolve("https://example.com/", relUrl: "//example2.com/one"));
        XCTAssertEqual("https://example.com:8080/one", StringUtil.resolve("https://example.com:8080", relUrl: "./one"));
        XCTAssertEqual("https://example2.com/one", StringUtil.resolve("http://example.com/", relUrl: "https://example2.com/one"));
        XCTAssertEqual("https://example.com/one", StringUtil.resolve("wrong", relUrl: "https://example.com/one"));
        XCTAssertEqual("https://example.com/one", StringUtil.resolve("https://example.com/one", relUrl: ""));
        XCTAssertEqual("", StringUtil.resolve("wrong", relUrl: "also wrong"));
        XCTAssertEqual("ftp://example.com/one", StringUtil.resolve("ftp://example.com/two/", relUrl: "../one"));
        XCTAssertEqual("ftp://example.com/one/two.c", StringUtil.resolve("ftp://example.com/one/", relUrl: "./two.c"));
        XCTAssertEqual("ftp://example.com/one/two.c", StringUtil.resolve("ftp://example.com/one/", relUrl: "two.c"));
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
        
    }
    
}
