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

import SwiftUI
import XCTest
@testable import MountainAirport

class MountainAirportTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    static let noneDateShortTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let now = Date()
    static let tomorrow = Date(timeInterval: 1.0.days, since: now)
    static let yesterday = Date(timeInterval: -1.0.days, since: now)
    static let minuteAgo = Date(timeInterval: -1.0.minutes, since: now)

    static let flight1 = FlightInformation(
        recordId: 1, airline: "fa1", number: "fn1", connection: "fc1",
        scheduledTime: tomorrow, currentTime: now, direction: .departure,
        status: .ontime, gate: "fg1"
    )

    static let flight2 = FlightInformation(
        recordId: 2, airline: "fa2", number: "fn2", connection: "fc2",
        scheduledTime: now, currentTime: nil, direction: .arrival,
        status: .delayed, gate: "fg2"
    )

    static let flight3 = FlightInformation(
        recordId: 3, airline: "fa3", number: "fn3", connection: "fc3",
        scheduledTime: yesterday, currentTime: minuteAgo, direction: .departure,
        status: .landed, gate: "fg3"
    )

    static let flight4 = FlightInformation(
        recordId: 4, airline: "fa4", number: "fn4", connection: "fc4",
        scheduledTime: now, currentTime: minuteAgo, direction: .departure,
        status: .cancelled, gate: "fg4"
    )

    static let flight5 = FlightInformation(
        recordId: 5, airline: "fa5", number: "fn5", connection: "fc5",
        scheduledTime: minuteAgo, currentTime: now, direction: .arrival,
        status: .departed, gate: "fg5"
    )

    static let flight6 = FlightInformation(
        recordId: 6, airline: "fa6", number: "fn6", connection: "fc6",
        scheduledTime: now, currentTime: minuteAgo, direction: .departure,
        status: .departed, gate: "fg6"
    )

    static let flight7 = FlightInformation(
        recordId: 7, airline: "fa7", number: "fn7", connection: "fc7",
        scheduledTime: tomorrow, currentTime: tomorrow, direction: .departure,
        status: .delayed, gate: "fg7"
    )

    static var flights = [flight1, flight2, flight3, flight4,
                          flight5, flight6, flight7]

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

    func testFlightInformation() throws {
        // MARK: Computed properties
        // scheduledTimeString
        XCTAssertEqual(
            Self.flight1.scheduledTimeString,
            Self.noneDateShortTimeDateFormatter.string(from: Self.tomorrow)
        )
        // currentTimeSSelf.tring
        XCTAssertEqual(Self.flight1.currentTimeString,
                       Self.noneDateShortTimeDateFormatter.string(from: Self.now))
        XCTAssertEqual(Self.flight2.currentTimeString, "N/A")
        // flightStatus
        XCTAssertEqual(Self.flight4.flightStatus, FlightStatus.cancelled.rawValue)
        XCTAssertEqual(Self.flight5.flightStatus, "Arrived")
        XCTAssertEqual(Self.flight3.flightStatus, "Departed")
        XCTAssertEqual(Self.flight2.flightStatus, FlightStatus.delayed.rawValue)
        // timeDifference
        XCTAssertEqual(Self.flight2.timeDifference, 60)
        let diff = Calendar.current.dateComponents([.minute],
                                                   from: Self.flight1.scheduledTime,
                                                   to: Self.flight1.currentTime!)
        XCTAssertEqual(Self.flight1.timeDifference, diff.minute!)
        // timelineColor
        XCTAssertEqual(Self.flight4.timelineColor, Color.red)
        XCTAssertEqual(Self.flight6.timelineColor, .green)
        XCTAssertEqual(Self.flight5.timelineColor, .yellow)
        XCTAssertEqual(Self.flight2.timelineColor, .purple)
        // MARK: Methods
        XCTAssertTrue(Self.flight4.isRebookAvailable())
        XCTAssertTrue(Self.flight7.isCheckInAvailable())
    }

    func testArrayFlightInformationExtension() throws {
        XCTAssertEqual(Self.flights.arrivals(), [Self.flight2, Self.flight5])
        let departures: [FlightInformation] = [
            Self.flight1, Self.flight3, Self.flight4, Self.flight6, Self.flight7,
        ]
        XCTAssertEqual(Self.flights.departures(), departures)
    }
}

extension Double {
    public var days: Double { self * 24 * 60 * 60 }
    public var hours: Double { self * 60 * 60 }
    public var minutes: Double { self * 60 }
}
