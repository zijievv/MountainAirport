/// Copyright (c) 2020 Razeware LLC
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
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import SwiftUI
@testable import MountainAirport

class MountainAirportTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAwardInformation() throws {
        let ai1 = AwardInformation(awardView: AnyView(Text("ai1")),
                                   title: "ai1",
                                   description: "ai1 description",
                                   awarded: true)
        let ai1mirror = AwardInformation(awardView: AnyView(Text("ai1")),
                                         title: "ai1",
                                         description: "ai1 description",
                                         awarded: true)
        let ai2 = AwardInformation(awardView: AnyView(Text("ai2")),
                                   title: "ai2", description: "description ai2",
                                   awarded: false)

        var hasherAi1 = Hasher()
        ai1.hash(into: &hasherAi1)

        var hasher = Hasher()
        hasher.combine("ai1")
        hasher.combine("ai1 description")
        hasher.combine(true)

        XCTAssertTrue(ai1 == ai1mirror)
        XCTAssertFalse(ai1 == ai2)
        XCTAssertEqual(hasherAi1.finalize(), hasher.finalize())
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
