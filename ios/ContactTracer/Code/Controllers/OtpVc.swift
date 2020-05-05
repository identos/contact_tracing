//
//  StepTwoVc.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-30.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class OtpVc: UIViewController {

    let delegate: NavigationStepDelegate

    let stepLabel: UILabel = UILabel(frame: .zero)
    let nextButton: UIButton = UIButton(type: .system)
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)
    let otpLabel: UILabel = UILabel(frame: .zero)
    let otpTextField: TextField = TextField(frame: .zero)

    private let userInfo = UserDefaults.standard

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
        stepLabel.text = "Step 2 of 3"
        stepLabel.font = Fonts.normalBold.get()
        stepLabel.textAlignment = .left
        view.addSubview(stepLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Enter your One-Time PIN (OTP)"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        let atts: [NSAttributedString.Key: Any] = [.font: Fonts.normalBold.get()]
        let startDesc = NSMutableAttributedString(string: """
                                                          You received a text message through the number provided in the previous step. Please check it, and enter the
                                                          """, attributes: nil)
        let endDesc = NSMutableAttributedString(string: " OTP.", attributes: atts)
        startDesc.append(endDesc)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = Fonts.description.get()
        descLabel.textAlignment = .justified
        descLabel.numberOfLines = 0
        descLabel.attributedText = startDesc
        view.addSubview(descLabel)

        otpLabel.translatesAutoresizingMaskIntoConstraints = false
        otpLabel.text = "OTP"
        otpLabel.font = Fonts.normalBold.get()
        otpLabel.textAlignment = .left
        otpLabel.numberOfLines = 1
        view.addSubview(otpLabel)

        otpTextField.translatesAutoresizingMaskIntoConstraints = false
        otpTextField.placeholder = ""
        otpTextField.layer.borderWidth = 1.0;
        otpTextField.layer.cornerRadius = 5.0;
        otpTextField.layer.borderColor = Colors.blue.uiColor().cgColor
        otpTextField.font = Fonts.description.get()
        otpTextField.textAlignment = .left
        otpTextField.keyboardType = .numberPad
        view.addSubview(otpTextField)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = Colors.blue.uiColor()
        nextButton.titleLabel?.font = Fonts.button.get()
        nextButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        nextButton.setTitle("Continue", for: .normal)
        nextButton.layer.cornerRadius = 12
        nextButton.isEnabled = false
        view.addSubview(nextButton)

        nextButton.addTarget(self,
            action: #selector(handleNextTouchUpInside),
            for: .touchUpInside)

        otpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        constraintsInit()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        nextButton.isEnabled = true
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
            otpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 30),
            otpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            otpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            otpTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpTextField.topAnchor.constraint(equalTo: otpLabel.bottomAnchor, constant: 20),
            otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    @objc func handleNextTouchUpInside() {

        nextButton.isEnabled = false

        ContactTracerAPI.confirmDevice(identifier: userInfo.appUUID!.uuidString, userCode: otpTextField.text ?? "", phone: userInfo.phoneNumber!).execute(
            completion: { (response: AddDeviceResponse?) in
                DispatchQueue.main.async {
                    self.userInfo.hasJoined = true
                    self.delegate.next()
                }
            },
            failure: { apiError in
                DispatchQueue.main.async {
                    self.nextButton.isEnabled = true
                    let alert = UIAlertController(title: String(apiError.status), message: apiError.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        )
    }
}
