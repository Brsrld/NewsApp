import Foundation

final class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    //MARK: Get All Data
    
        public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void) {
            guard let url = Constants.topHeadLinesURL else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }else if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        
                        completion(.success(result.articles))
                        
                    }
                    catch {
                        completion(.failure(error))
                        
                    }
                }
            }
            task.resume()
        }

    //MARK: Search
    
    public func search(with query:String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


