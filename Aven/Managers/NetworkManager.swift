
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/organizations"
    private let session = URLSession.shared
    
    private init() {}
    
    func loadOrganizations(completion: @escaping ([Organization])->()) {
        let request = URLRequest(url: URL(string: self.baseURL) ?? URL(fileURLWithPath: ""))
        session.dataTask(with: request) { (data,response,error) in
            if let error = error {
                print("Error creating dataTask - \(error.localizedDescription)")
            } else if let data = data {
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let organizations = try decoder.decode([Organization].self,from: data)
                        completion(organizations)
                    } catch let error {
                        print("Error parsing Location JSON - \(error.localizedDescription)")
                    }
                }
            } else {
                print("There was an error with the HTTP Response")
            }
        }.resume()
    }
}
