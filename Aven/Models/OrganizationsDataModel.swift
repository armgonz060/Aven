
import SwiftUI
import Combine
import Foundation

final class OrganizationsDataModel: ObservableObject {
    @Published var organizationsList: [Organization] = []
    
    private let testData = [
        Organization(
            name: "errfree",
            url: "https://api.github.com/orgs/errfree",
            avatarURL: "https://avatars.githubusercontent.com/u/44?v=4",
            description: ""
        ),
        Organization(
            name: "engineyard",
            url: "https://api.github.com/orgs/engineyard",
            avatarURL: "https://avatars.githubusercontent.com/u/81?v=4",
            description: "This is a test description"
        )
    ]
    
    init(isTesting: Bool = false) {
        if isTesting {
            self.organizationsList = self.testData
        } else {
            self.loadOrganizationsList()
        }
    }
    
    private func loadOrganizationsList() {
        NetworkManager.shared.loadOrganizations { [weak self] organizations in
            guard let self = self else { return }
            self.organizationsList = organizations
        }
    }
}

class Organization: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let url: String
    let avatarURL: String
    let description: String
    var image: AsyncImage?
    
    init(name: String, url: String, avatarURL: String, description: String) {
        self.name = name
        self.url = url
        self.avatarURL = avatarURL
        self.description = description
        
        defer {
            self.loadImages()
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.url = (try? container?.decodeIfPresent(String.self, forKey: .url)) ?? ""
        self.name = (try? container?.decodeIfPresent(String.self, forKey: .name)) ?? ""
        self.avatarURL = (try? container?.decodeIfPresent(String.self, forKey: .avatarURL)) ?? ""
        self.description = (try? container?.decodeIfPresent(String.self, forKey: .description)) ?? ""
        
        defer {
            self.loadImages()
        }
    }
    
    private func loadImages() {
        if !self.avatarURL.isEmpty, let url = URL(string: self.avatarURL) {
            self.image = AsyncImage(url: url)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case url
        case description
        case name = "login"
        case avatarURL = "avatar_url"
    }
}
