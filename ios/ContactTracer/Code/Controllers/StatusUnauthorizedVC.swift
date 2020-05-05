//
// Created by Leigh Williams on 2020-03-31.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class StatusUnauthorizedVc: UIViewController {

    let delegate: NavigationStepDelegate

    let appAlertImage: UIImageView = UIImageView(image: UIImage(named: "permission"))
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)
    let faqLabel: UILabel = UILabel(frame: .zero)
    let nextButton: UIButton = UIButton(type: .system)

    init(delegate: NavigationStepDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white


        appAlertImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appAlertImage)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "You have not allowed permission to connect"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.text = "When you allow permission to connect to the app, you help contact tracing do its job to slow down the spread of COVID-19 and prevent further infections.."
        descLabel.font = Fonts.description.get()
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        view.addSubview(descLabel)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = Colors.blue.uiColor()
        nextButton.titleLabel?.font = Fonts.button.get()
        nextButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        nextButton.setTitle("Allow Permission", for: .normal)
        nextButton.layer.cornerRadius = 12
        view.addSubview(nextButton)

        nextButton.addTarget(self,
            action: #selector(handleNextTouchUpInside),
            for: .touchUpInside)

        constraintsInit()
    }

    private func constraintsInit() {

        NSLayoutConstraint.activate([
            appAlertImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appAlertImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            appAlertImage.heightAnchor.constraint(equalToConstant: 384/4),
            appAlertImage.widthAnchor.constraint(equalToConstant: 384/4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: appAlertImage.bottomAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    @objc func handleNextTouchUpInside() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

}
