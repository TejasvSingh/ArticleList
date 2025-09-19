
import Foundation
protocol NetworkManagerProtocol: AnyObject {
    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void)
    func parse(data: Data?) -> [Country]
}
class CountryNetworkManager: NetworkManagerProtocol {
    static let shared = CountryNetworkManager()
    var state: NetworkState = .isLoading
     init() {}

    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void) {
        guard let serverURL = URL(string: serverUrl ?? "") else {
            state = .invalidURL
            closure(state)
            return
        }
        
        URLSession.shared.dataTask(with: serverURL) { data, response, error in
            if let _ = error {
                self.state = .errorFetchingData
                closure(self.state)
                return
            }
            
            guard let data else {
                self.state = .noDataFromServer
                closure(self.state)
                return
            }
            self.state = .success(data)
            closure(self.state)
        }.resume()
    }

    func parse(data: Data?) -> [Country] {
        guard let data = data else {
            print("No data to parse")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode([Country].self, from: data)
            return fetchedResult
        } catch {
            print(error)
        }
        return []
    }

}
