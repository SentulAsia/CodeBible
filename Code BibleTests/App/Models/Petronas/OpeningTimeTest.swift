/// Copyright © 2019 Zaid M. Said
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import Code_Bible

class OpeningTimeTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOpeningTimeList() {
        // given
        let validString = "Mon-Sun 11:30 am - 9:00 pm"
        let expectedResult = [
            OpeningTime(day: .mon, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .tue, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .wed, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .thu, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .fri, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .sat, time: "11:30 am - 9:00 pm"),
            OpeningTime(day: .sun, time: "11:30 am - 9:00 pm")
        ]
        
        // when
        let actualResult = OpeningTime.list(content: validString)
        
        //then
        XCTAssertEqual(actualResult.first.debugDescription, expectedResult.first.debugDescription, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult[1].description, expectedResult[1].description, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult[2].description, expectedResult[2].description, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult[3].description, expectedResult[3].description, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult[4].description, expectedResult[4].description, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult[5].description, expectedResult[5].description, "list(content:) should generate correct string")
        XCTAssertEqual(actualResult.last.debugDescription, expectedResult.last.debugDescription, "list(content:) should generate correct string")
    }
}
