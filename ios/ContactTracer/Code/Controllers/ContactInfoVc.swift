//
//  ContactInfoVc.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-30.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class ContactInfoVc: UIViewController {

    let delegate: NavigationStepDelegate
    let stepLabel: UILabel = UILabel(frame: .zero)
    let nextButton: UIButton = UIButton(type: .system)
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)
    let mobileLabel: UILabel = UILabel(frame: .zero)
    let countryCodeLabel: UILabel = UILabel(frame: .zero)
    let phoneTextField: TextField = TextField(frame: .zero)
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

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.backgroundColor = .white

        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.text = "Step 1 of 3"
        stepLabel.font = Fonts.normalBold.get()
        stepLabel.textAlignment = .left
        stepLabel.numberOfLines = 0
        view.addSubview(stepLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Enter your mobile number to be contacted"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        mobileLabel.translatesAutoresizingMaskIntoConstraints = false
        mobileLabel.text = "Mobile Phone Number"
        mobileLabel.font = Fonts.normalBold.get()
        mobileLabel.textAlignment = .left
        mobileLabel.numberOfLines = 1
        view.addSubview(mobileLabel)
        
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel.text = "+1"
        countryCodeLabel.font = Fonts.normalBold.get()
        countryCodeLabel.textAlignment = .right
        countryCodeLabel.numberOfLines = 1
        view.addSubview(countryCodeLabel)

        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.placeholder = ""
        phoneTextField.layer.borderWidth = 1.0;
        phoneTextField.layer.cornerRadius = 5.0;
        phoneTextField.layer.borderColor = Colors.blue.uiColor().cgColor
        phoneTextField.font = Fonts.description.get()
        phoneTextField.textAlignment = .left
        phoneTextField.keyboardType = .phonePad
        view.addSubview(phoneTextField)


        let atts: [NSAttributedString.Key: Any] = [.font: Fonts.normalBold.get()]

        let first = NSMutableAttributedString(string: "The Ontario Ministry of Health will use this information only contact you if it is needed for contact tracing.\n\nWe will also send you a", attributes: nil)
        let second = NSMutableAttributedString(string: " One-Time Pin (OTP)", attributes: atts)
        let third = NSMutableAttributedString(string: " to confirm that this number belongs to you, and it is correct.", attributes: nil)

        first.append(second)
        first.append(third)

        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = Fonts.description.get()
        descLabel.textAlignment = .justified
        descLabel.attributedText = first
        descLabel.numberOfLines = 0
        view.addSubview(descLabel)


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

        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

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
            mobileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mobileLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            mobileLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mobileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            countryCodeLabel.topAnchor.constraint(equalTo: mobileLabel.bottomAnchor, constant: 22),
            countryCodeLabel.widthAnchor.constraint(equalToConstant: 20),
            countryCodeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneTextField.topAnchor.constraint(equalTo: mobileLabel.bottomAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 10),
            descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])

    }

    @objc func handleNextTouchUpInside() {

        let phoneNumber = "1" + phoneTextField.text!.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)

        nextButton.isEnabled = false

        ContactTracerAPI.addDevice(identifier: userInfo.appUUID!.uuidString, phone: phoneNumber).execute(
            completion: { (response: AddDeviceResponse?) in
                DispatchQueue.main.async {
                    self.userInfo.phoneNumber = phoneNumber
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

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let topKeyboard = self.view.frame.height - keyboardSize.height
                let bottomButton = self.nextButton.frame.height + self.nextButton.frame.origin.y

                if bottomButton > topKeyboard {
                    self.view.frame.origin.y -= (bottomButton - topKeyboard)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
