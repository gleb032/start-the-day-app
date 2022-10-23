//
//  LabelFactory.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 23.10.2022.
//

import UIKit

final class LabelFactory {
    static func makeLabel(
        text: String = "",
        alignment: NSTextAlignment = .left,
        font: UIFont = .boldSystemFont(ofSize: 15)
    ) -> UILabel {
        return {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = alignment
            label.text = text
            label.font = font
            label.isUserInteractionEnabled = false
            label.numberOfLines = 0
            label.sizeToFit()
            return label
        }()
    }
}
