//
//  AlertController.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 23.10.2022.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(
        withTitle title: String?,
        message: String?,
        style: UIAlertController.Style,
        completionHandler: @escaping (String) -> Void
    ) {

        let allertController = UIAlertController(title: title, message: message, preferredStyle: style)

        allertController.addTextField(configurationHandler: { textField in
            textField.placeholder = randomCities.randomElement()
        })

        let search = UIAlertAction(title: "Search", style: .default) { _ in
            let textField = allertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if !cityName.isEmpty {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        allertController.addAction(search)
        allertController.addAction(cancel)
        present(allertController, animated: true)
    }
}
