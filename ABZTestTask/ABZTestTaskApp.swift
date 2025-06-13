
import SwiftUI
import Network

@main
struct ABZTestTaskApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            if networkMonitor.isConnected {
                MainTabView()
            } else {
                NoConnectionView {
                    networkMonitor.checkConnection()
                }
            }
        }
    }
}
