import Foundation

protocol ArticleNetwork {
    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void)
    func parse(data: Data?) -> News?
}


class ArticleNetworkManager: ArticleNetwork {
    static let shared = ArticleNetworkManager()
    private init() {}

    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void) {
        guard let serverURL = URL(string: serverUrl) else {
            print("Server URL is invalid")
            closure(nil)
            return
        }

        URLSession.shared.dataTask(with: serverURL) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                closure(nil)
                return
            }
            closure(data)
        }.resume()
    }

    func parse(data: Data?) -> News? {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(News.self, from: data)
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
