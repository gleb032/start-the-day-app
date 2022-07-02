//
//  NetworkQuoteManager.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 30.06.2022.
//

import Foundation


struct NetworkQuoteManager {
    
    var onComplition: ((RandomQuote) -> Void)?
    
    func fetchRandomQuote() {
        let urlString = "https://zenquotes.io/api/random?"
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let dataSafe = data {
                if let randomQuote = self.parseJSON(withData: dataSafe) {
                    self.onComplition?(randomQuote)
//                    print(randomQuote.quote)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> RandomQuote? {
        let decoder = JSONDecoder()
        do {
            let randomQouteData = try decoder.decode([RandomQuoteData].self, from: data)
            guard let randomQuote = RandomQuote(randomQuoteData: randomQouteData[0]) else {
                return nil
            }
            return randomQuote
        } catch let error as NSError {
//            print("!!!!!!!!!!!!")
            print(error)
        }
        return nil
    }
}
