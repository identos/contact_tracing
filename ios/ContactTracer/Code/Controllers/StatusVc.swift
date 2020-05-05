//
// Created by Leigh Williams on 2020-03-31.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class StatusVc: UIViewController {

    let delegate: NavigationStepDelegate

    let blueToothImage: UIImageView = UIImageView(image: UIImage(named: "bluetooth"))
    let titleLabel: UILabel = UILabel(frame: .zero)
    let descLabel: UILabel = UILabel(frame: .zero)
    let faqLabel: UILabel = UILabel(frame: .zero)
    let shareLabel: UILabel = UILabel(frame: .zero)
    let shareSwitch: UISwitch = UISwitch(frame: .zero)
    let whatHappensLabel: UILabel = UILabel(frame: .zero)
    let shareAppButton: UIButton = UIButton(type: .system)
    let positiveTestButton: UIButton = UIButton(type: .system)
    let endLabel: UILabel = UILabel(frame: .zero)


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

        blueToothImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blueToothImage)
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = Fonts.description.get()
        descLabel.text = """
        Keep Bluetooth on to help stop COVID-19.
        Continue sharing in the background to
        improve tracking effectiveness!
        """

        descLabel.numberOfLines = 0
        view.addSubview(descLabel)

        shareLabel.translatesAutoresizingMaskIntoConstraints = false
        shareLabel.text = "Share when app is running in the background?"
        shareLabel.font = Fonts.normalMedium.get()
        shareLabel.numberOfLines = 0
        shareLabel.textAlignment = .left
        view.addSubview(shareLabel)

        shareSwitch.translatesAutoresizingMaskIntoConstraints = false
        shareSwitch.onTintColor = Colors.blue.uiColor()
        view.addSubview(shareSwitch)

        whatHappensLabel.translatesAutoresizingMaskIntoConstraints = false
        whatHappensLabel.font = Fonts.normalMedium.get()
        whatHappensLabel.textColor = Colors.blue.uiColor()
        whatHappensLabel.textAlignment = .left
        whatHappensLabel.attributedText = NSAttributedString(string: "What happens to my data?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        view.addSubview(whatHappensLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "You are participating in contact tracing"
        titleLabel.font = Fonts.title.get()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        shareAppButton.translatesAutoresizingMaskIntoConstraints = false
        shareAppButton.backgroundColor = Colors.white.uiColor()
        shareAppButton.titleLabel?.font = Fonts.button.get()
        shareAppButton.setTitleColor(Colors.blue.uiColor(), for: .normal)
        shareAppButton.layer.borderColor = Colors.blue.uiColor().cgColor
        shareAppButton.layer.borderWidth = 2
        shareAppButton.setTitle("Share This App", for: .normal)
        shareAppButton.layer.cornerRadius = 12
        view.addSubview(shareAppButton)

        shareAppButton.addTarget(self,
            action: #selector(handleShareTouchUpInside),
            for: .touchUpInside)
        
        positiveTestButton.translatesAutoresizingMaskIntoConstraints = false
        positiveTestButton.backgroundColor = Colors.blue.uiColor()
        positiveTestButton.titleLabel?.font = Fonts.button.get()
        positiveTestButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        positiveTestButton.setTitle("I Have Tested Positive", for: .normal)
        positiveTestButton.layer.cornerRadius = 12
        view.addSubview(positiveTestButton)
        
        positiveTestButton.addTarget(self,
        action: #selector(handleEventsTouchUpInside),
        for: .touchUpInside)

        let atts: [NSAttributedString.Key: Any] = [
            .font: Fonts.normalMedium.get(),
            .foregroundColor: Colors.blue.uiColor(),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let startDesc = NSMutableAttributedString(string: """
                                                          If you test positive, then tap to learn how to share your contacts. For more info, see our
                                                          """, attributes: nil)
        let endDesc = NSMutableAttributedString(string: " FAQ.", attributes: atts)
        startDesc.append(endDesc)
        
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.attributedText = startDesc
        endLabel.font = Fonts.description.get()
        endLabel.textAlignment = .center
        endLabel.numberOfLines = 0
        view.addSubview(endLabel)

        constraintsInit()
    }

    private func constraintsInit() {

        NSLayoutConstraint.activate([
            blueToothImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            blueToothImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            blueToothImage.heightAnchor.constraint(equalToConstant: 192/4),
            blueToothImage.widthAnchor.constraint(equalToConstant: 176/4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: blueToothImage.bottomAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            shareLabel.trailingAnchor.constraint(equalTo: shareSwitch.leadingAnchor, constant: -10),
            shareLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareSwitch.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            shareSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shareSwitch.widthAnchor.constraint(equalToConstant: 50),
            whatHappensLabel.topAnchor.constraint(equalTo: shareLabel.bottomAnchor, constant: 8),
            whatHappensLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            whatHappensLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareAppButton.topAnchor.constraint(equalTo: whatHappensLabel.bottomAnchor, constant: 30),
            shareAppButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shareAppButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shareAppButton.heightAnchor.constraint(equalToConstant: 60),
            
            positiveTestButton.topAnchor.constraint(equalTo: shareAppButton.bottomAnchor, constant: 30),
            positiveTestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            positiveTestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            positiveTestButton.heightAnchor.constraint(equalToConstant: 60),
            endLabel.topAnchor.constraint(equalTo: positiveTestButton.bottomAnchor, constant: 20),
            endLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

    }
    
    @objc func handleEventsTouchUpInside() {
        let vc = ContactEventsVc()
        let presenting = UIApplication.getTopViewController()
        presenting!.present(vc, animated: true)
    }

    @objc func handleShareTouchUpInside() {
    }

}
