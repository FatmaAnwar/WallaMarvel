import Foundation

protocol APIClientProtocol {
    func getHeroes(offset: Int, completionBlock: @escaping (CharacterDataContainer) -> Void)
}

final class APIClient: APIClientProtocol {
    enum Constant {
        static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        static let publicKey = "d575c26d5c746f623518e753921ac847"
    }
    
    init() { }
    
    func getHeroes(offset: Int, completionBlock: @escaping (CharacterDataContainer) -> Void) {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = Constant.privateKey
        let publicKey = Constant.publicKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        
        let parameters: [String: String] = [
            "apikey": publicKey,
            "ts": ts,
            "hash": hash,
            "offset": "\(offset)"
        ]
        
        var urlComponent = URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters")
        urlComponent?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let urlRequest = URLRequest(url: urlComponent!.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            if let data = data {
                let decoded = try! JSONDecoder().decode(CharacterDataContainer.self, from: data)
                completionBlock(decoded)
            }
        }.resume()
    }
}
