
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
    private var cache = URLCache.shared
    
    func loadImage(fromURL urlString: String) {
        guard let url = URL(string: urlString) else {
            self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        if let data = cache.cachedResponse(for: URLRequest(url: url))?.data,
           let image = UIImage(data: data) {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.error = error
                    return
                }
                
                
                guard let data = data, let response = response, let image = UIImage(data: data) else {
                    self?.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data or response error"])
                    return
                }
                
                let cachedData = CachedURLResponse(response: response, data: data)
                self?.cache.storeCachedResponse(cachedData, for: URLRequest(url: url))
                self?.image = image
            }
        }
        .resume()
    }
}
