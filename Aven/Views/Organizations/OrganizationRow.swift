
import SwiftUI

struct OrganizationRow: View {
    var organization: Organization
    
    var body: some View {
        HStack {
            organization.image
            
            VStack(alignment: .leading) {
                Text(organization.name)
                    .font(.headline)
                if !organization.description.isEmpty {
                    Text(organization.description)
                        .font(.callout)
                }
                if let url = URL(string: organization.url) {
                    Link(organization.url, destination: url)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct OrganizationRow_Previews: PreviewProvider {
    static let organizations = OrganizationsDataModel(isTesting: true).organizationsList
    
    static var previews: some View {
        Group {
            ForEach(self.organizations) { organization in
                OrganizationRow(organization: organization)
            }
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
