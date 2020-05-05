//
//  ViewController.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-03-26.
//  Copyright © 2020 Identos. All rights reserved.
//

import UIKit
import CoreBluetooth

class ContactTracerAppVc: UIViewController, ContactBluetoothDelegate {

    private var contactManager: ContactManager!
    private var currentStep: NavigationStep?
    private let userInfo = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(true)

        guard currentStep == nil else {
            return
        }

        switch userInfo.hasJoined {
        case true:
            startContactManager()
            currentStep = .status
        case false:
            currentStep = .info
        }

        let toVc = currentStep!.viewController(delegate: self)
        present(toVc, animated: false, completion: nil)
    }


    func present(step: NavigationStep) {

        guard step != currentStep else {return}

        if currentStep == NavigationStep.turnOnBluetooth {
            startContactManager()
        }

        let fromVc = UIApplication.getTopViewController(base: self)!
        let nextVc = step.viewController(delegate: self)
        let transitionDelegate = TransitionDelegate()

        fromVc.transitioningDelegate = transitionDelegate

        fromVc.dismiss(animated: true, completion: {
            nextVc.transitioningDelegate = transitionDelegate
            self.present(nextVc, animated: true)
        })

        currentStep = step
    }
}

extension ContactTracerAppVc {

    func startContactManager() {
        contactManager = ContactManager(config: userInfo.loadContactConfig())
        contactManager.delegate = self
    }

    func bluetoothStatusUpdated(state: CBManagerState) {
        switch (state) {
        case .unauthorized:
            present(step: .statusUnauthorized)
        case .poweredOff:
            present(step: .statusOff)
        case .poweredOn:
            present(step: .status)
        default:
            print("Bluetooth Status Updated: \(state)")
        }
    }

}


extension ContactTracerAppVc: NavigationStepDelegate {

    func next() {
        present(step: currentStep!.next())
    }
}

extension NavigationStep {

    func viewController(delegate: NavigationStepDelegate) -> UIViewController {
        switch self {

        case .info:
            return InfoVc(delegate: delegate)
        case .contactInfo:
            return ContactInfoVc(delegate: delegate)
        case .otp:
            return OtpVc(delegate: delegate)
        case .turnOnBluetooth:
            return TurnOnBluetoothVc(delegate: delegate)
        case .status:
            return StatusVc(delegate: delegate)
        case .statusOff:
            return StatusOffVc(delegate: delegate)
        case .statusUnauthorized:
            return StatusUnauthorizedVc(delegate: delegate)
        }
    }
}



