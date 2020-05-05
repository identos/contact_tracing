//
//  StepThreeVc.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-30.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class TurnOnBluetoothVc: UIViewController {

    let delegate: NavigationStepDelegate

    var stepLabel: UILabel = UILabel(frame: .zero)
    let nextButton = UIButton(type: .system)
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)

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

        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.text = "Step 3 of 3"
        stepLabel.font = Fonts.normalBold.get()
        stepLabel.textAlignment = .left
        stepLabel.numberOfLines = 0
        view.addSubview(stepLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Get Started: Turn on your Bluetooth"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: Fonts.description.get()
        ]
        
        let string = "Join us against COVID-19 to help protect yourself and your community!\n\nYour Bluetooth signal will identify if you are near another user of the app. This proximity data is encrypted and stored only on your phone.\n\nWhen you ensure Bluetooth is on every time you leave your house, you help keep track of the spread of COVID-19.\n\nFor more information, see our FAQ."
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.attributedText = NSAttributedString(string: string, attributes: attributes)
        descLabel.numberOfLines = 0
        view.addSubview(descLabel)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = Colors.blue.uiColor()
        nextButton.titleLabel?.font = Fonts.button.get()
        nextButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        nextButton.setTitle("I want to help", for: .normal)
        nextButton.layer.cornerRadius = 12
        view.addSubview(nextButton)

        nextButton.addTarget(self,
            action: #selector(handleNextTouchUpInside),
            for: .touchUpInside)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = Colors.blue.uiColor()
        nextButton.titleLabel?.font = Fonts.button.get()
        nextButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        nextButton.setTitle("I have turned on Bluetooth", for: .normal)
        nextButton.layer.cornerRadius = 12
        view.addSubview(nextButton)

        nextButton.addTarget(self,
            action: #selector(handleNextTouchUpInside),
            for: .touchUpInside)

        constraintsInit()
    }

    private func constraintsInit() {

        NSLayoutConstraint.activate([
            stepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            stepLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stepLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func handleNextTouchUpInside() {
        delegate.next()
    }

}
