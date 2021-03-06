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

struct CheckInInfo: Identifiable {
    let id = UUID()
    let airline: String
    let flight: String
}

struct FlightBoardInformation: View {
    var flight: FlightInformation
    @Binding var showModal: Bool
    @State private var rebookAlert: Bool = false
    @State private var checkInFlight: CheckInInfo?
    @State private var showFlightHistory = false
    @State private var showDetails: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            doneButton.foregroundColor(.blue)

            List {
                flightInfo
                Divider()

                Group {
                    if flight.isRebookAvailable() { rebookButton }
                    if flight.isCheckInAvailable() { checkInButton }
                    onTimeHistoryButton
                    Divider()
                    showDetailsButton
                }
                .foregroundColor(.blue)

                FlightDetails(flight: flight)
                    .offset(x: showDetails ? 0 : -UIScreen.main.bounds.width)
                    .animation(Animation.spring().delay(0.1).speed(1.5))
            }
            .environment(\.defaultMinListRowHeight, 0)
            .onAppear { UITableView.appearance().separatorStyle = .none }
        }
        .font(.headline)
        .padding()
    }
}

struct FlightBoardInformation_Previews: PreviewProvider {
    @State static var showModal: Bool = true

    static var previews: some View {
        FlightBoardInformation(flight: FlightInformation.generateFlight(),
                               showModal: self.$showModal)
    }
}

extension FlightBoardInformation {
    var doneButton: some View {
        HStack {
            Spacer()
            Button("Done") {
                self.showModal = false
            }
        }
    }

    var flightInfo: some View {
        Group {
            HStack {
                Text("\(flight.airline) Flight \(flight.number)")
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.vertical)

            Text("\(flight.direction == .arrival ? "From: " : "To: ")" +
                "\(flight.otherAirport)")
            Text(flight.flightStatus)
                .foregroundColor(flight.timelineColor)
        }
    }

    var rebookButton: some View {
        Button("Rebook Flight") {
            self.rebookAlert = true
        }
        .alert(isPresented: self.$rebookAlert) {
            Alert(
                title: Text("Contact Your Airline"),
                message: Text(
                    "We cannot rebook this flight.\n" +
                        "Please contact the airline to reschedule this flight."
                )
            )
        }
    }

    var checkInButton: some View {
        Button("Check In for Flight") {
            self.checkInFlight = CheckInInfo(airline: self.flight.airline,
                                             flight: self.flight.number)
        }
        .actionSheet(item: $checkInFlight) { flight in
            ActionSheet(
                title: Text("Check In"),
                message: Text("Check in for \(flight.airline) "
                    + "Flight \(flight.flight)"),
                buttons: [
                    .cancel(Text("Not Now")),
                    .destructive(Text("Reschedule"), action: {
                        print("Reschedule flight.")
                    }),
                    .default(Text("Check In"), action: {
                        print("Check-in for \(flight.airline) \(flight.flight)")
                    }),
                ]
            )
        }
    }

    var onTimeHistoryButton: some View {
        Button("On-Time History") {
            self.showFlightHistory.toggle()
        }
        .popover(isPresented: $showFlightHistory, arrowEdge: .top) {
            FlightTimeHistory(flight: self.flight,
                              showHistory: self.$showFlightHistory)
        }
    }

    var showDetailsButton: some View {
        Button(action: {
            self.showDetails.toggle()
        }) {
            HStack {
                Text(showDetails ? "Hide Details" : "Show Details")
                Spacer()
                Image(systemName: "chevron.up.square")
                    .scaleEffect(showDetails ? 1.5 : 1)
                    .rotationEffect(.degrees(showDetails ? 0 : 180))
                    .animation(.easeInOut)
            }
        }
    }
}
