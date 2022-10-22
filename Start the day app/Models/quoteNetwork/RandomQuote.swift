//
//  RandomQuote.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 01.07.2022.
//

import Foundation

struct RandomQuote {
    let quote: String
    let author: String

    init?(randomQuoteData: RandomQuoteData) {
        quote = randomQuoteData.quote
        author = randomQuoteData.author
    }
}
