import UIKit

class QuotesItemController {
    
    func fetchItems(completion: @escaping (Result<[Quotes], Error>) -> Void) {
        let url = URL(string: "https://mboum.com/api/v1/co/collections/?list=growth_technology_stocks&start=1&apikey=demo")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(JSONStructure.self, from: data)
                    completion(.success(searchResponse.quotes))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }

}
