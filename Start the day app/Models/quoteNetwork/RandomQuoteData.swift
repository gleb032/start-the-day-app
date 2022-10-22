//
//  RandomQuoteData.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 01.07.2022.
//

import Foundation

struct RandomQuoteData: Decodable {
    let quote: String
    let author: String

    enum CodingKeys: String, CodingKey {
        case quote = "q"
        case author = "a"
    }
}
