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
// TimelineTableViewCell: https://github.com/kf99916/TimelineTableViewCell.git
import TimelineTableViewCell

class Coordinator: NSObject {
    var flightData: [FlightInformation]

    init(flights: [FlightInformation]) {
        self.flightData = flights
    }
}

extension Coordinator: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return flightData.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateStyle = .none

        let flight = self.flightData[indexPath.row]
        let scheduledString = timeFormatter.string(from: flight.scheduledTime)
        let currentString = timeFormatter
            .string(from: flight.currentTime ?? flight.scheduledTime)

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TimelineTableViewCell",
            for: indexPath
        ) as! TimelineTableViewCell

        let flightInfo = "\(flight.airline) \(flight.number)" +
            "\(flight.direction == .departure ? "to" : "from")" +
            " \(flight.otherAirport) - \(flight.flightStatus)"

        cell.descriptionLabel.text = flightInfo

        if flight.status == .cancelled {
            cell.titleLabel.text = "Cancelled"
        } else if flight.timeDifference != 0 {
            let title = "\(scheduledString) Now: \(currentString)"
            cell.titleLabel.text = title
        } else {
            cell.titleLabel.text = "On Time for \(scheduledString)"
        }

        cell.titleLabel.textColor = UIColor.black
        cell.bubbleColor = flight.timelineColor.toUIColor

        return cell
    }
}

struct FlightTimeline: UIViewControllerRepresentable {
    var flights: [FlightInformation]

    func makeCoordinator() -> Coordinator {
        Coordinator(flights: flights)
    }

    func makeUIViewController(context: Context) -> UITableViewController {
        UITableViewController()
    }

    func updateUIViewController(
        _ viewController: UITableViewController,
        context: Context
    ) {
        viewController.tableView.dataSource = context.coordinator
        let timelineTableViewCellNib = UINib(
            nibName: "TimelineTableViewCell",
            bundle: Bundle.main
        )

        viewController.tableView.register(
            timelineTableViewCellNib,
            forCellReuseIdentifier: "TimelineTableViewCell"
        )
    }
}

public extension Color {
    typealias RGBAlpha = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

    /// Converts `Color` to `UIColor`
    var toUIColor: UIColor {
        let components = self.components()
        return UIColor(
            red: components.r,
            green: components.g,
            blue: components.b,
            alpha: components.a
        )
    }

    private func components() -> RGBAlpha {
        let scanner = Scanner(string: self.description
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
