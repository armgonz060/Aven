
import SwiftUI

struct OrganizationsList: View {
    private enum Constants {
        static let navigationTitle = "Organizations"
    }
    
    @EnvironmentObject var organizationsData: OrganizationsDataModel
    
    var body: some View {
        NavigationView {
            List(organizationsData.organizationsList) { organization in
                OrganizationRow(organization: organization)
            }
            .navigationTitle(Text(Constants.navigationTitle))
        }
    }
}

struct OrganizationsList_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationsList()
            .environmentObject(OrganizationsDataModel(isTesting: true))
    }
}
