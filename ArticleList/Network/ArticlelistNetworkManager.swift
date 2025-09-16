import Foundation

protocol ArticleNetwork {
    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void)
    func parse(data: Data?) -> [ArticleList]
}


class ArticleNetworkManager: ArticleNetwork {
    static let shared = ArticleNetworkManager()
    var state: NetworkState = .isLoading
     init() {}

    func getData(from serverUrl: String?, closure: @escaping (NetworkState) -> Void) {
        guard let imageUrl = serverUrl, let serverURL = URL(string: imageUrl) else {
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

    func parse(data: Data?) -> [ArticleList] {
        guard let data = data else {
            print("No data to parse")
            return []
        }
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode(News.self, from: data)
            return fetchedResult.articles
        } catch {
            print(error)
        }
        return []
    }

}
