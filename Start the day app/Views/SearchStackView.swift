//
//  SearchStackView.swift
//  Start the day app
//
//  Created by Глеб Фандеев on 21.10.2022.
//

import UIKit

class SearchStackView: UIStackView {
    private let weaterLabel = LabelFactory.makeLabel(text: "Search")
    private let cityName = LabelFactory.makeLabel(text: "City")
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "magnifyingglass"), for: .normal
        )
        button.frame.size = CGSize(width: 40, height: 40)
        button.layer.cornerRadius = button.frame.height / 2
        return button
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        return sv
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 5

        stackView.addArrangedSubview(cityName)
        stackView.addArrangedSubview(searchButton)

        addArrangedSubview(weaterLabel)
        addArrangedSubview(stackView)
    }

    func updateUI(with name: String) {
        cityName.text = name
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
