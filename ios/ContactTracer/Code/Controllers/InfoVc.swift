//
//  InfoVc.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-30.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit


class InfoVc: UIViewController {

    let delegate: NavigationStepDelegate

    let appImage: UIImageView = UIImageView(image: UIImage(named: "community"))
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)
    let descLabelTwo: UILabel = UILabel(frame: .zero)
    let whatHappensLabel: UILabel = UILabel(frame: .zero)
    let nextButton = UIButton(type: .system)


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
        
        
        appImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appImage)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Help us stop the spread of COVID-19"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.text = """
                         Enable the Ontario Ministry of Health to contact you directly if you have been in close contact with a case of COVID-19.
                         """

        descLabel.font = Fonts.description.get()
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        view.addSubview(descLabel)
        
        descLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        descLabelTwo.text = """
                            Protect you and your community, and
                            stop the infection by turning on
                            Bluetooth.
                         """

        descLabelTwo.font = Fonts.normalBold.get()
        descLabelTwo.textAlignment = .center
        descLabelTwo.numberOfLines = 0
        view.addSubview(descLabelTwo)

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

        whatHappensLabel.translatesAutoresizingMaskIntoConstraints = false
        whatHappensLabel.font = Fonts.normalMedium.get()
        whatHappensLabel.textColor = Colors.blue.uiColor()
        whatHappensLabel.textAlignment = .center
        whatHappensLabel.text = "How does this work?"
        view.addSubview(whatHappensLabel)

        constraintsInit()
    }

    private func constraintsInit() {


        NSLayoutConstraint.activate([
            appImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            appImage.heightAnchor.constraint(equalToConstant: 264/4),
            appImage.widthAnchor.constraint(equalToConstant: 384/4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: appImage.bottomAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabelTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabelTwo.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            descLabelTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabelTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.topAnchor.constraint(equalTo: descLabelTwo.bottomAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            whatHappensLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whatHappensLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            whatHappensLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            whatHappensLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

    }

    @objc func handleNextTouchUpInside() {
        delegate.next()
    }

}
