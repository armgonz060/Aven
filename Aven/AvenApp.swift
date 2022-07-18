
import SwiftUI

@main
struct AvenApp: App {
    @StateObject private var organizationsData = OrganizationsDataModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.organizationsData)
        }
    }
}
