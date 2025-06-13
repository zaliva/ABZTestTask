import SwiftUI

private let USE_TEST_SERVER = true

var baseUrl: String { "https://\(baseHostString)" }
private var baseHostString: String { USE_TEST_SERVER ? testHostName : hostName }

let testHostName = "frontend-test-assignment-api.abz.agency"
private var hostName = ""

let mainTextColor = Color(hex: "#000000", opacity: 0.87)
