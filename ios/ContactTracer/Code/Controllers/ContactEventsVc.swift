//
// Created by Leigh Williams on 2020-04-03.
// Copyright (c) 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class ContactEventsVc: UIViewController, UITableViewDelegate, UITableViewDataSource {

    init() {
        self.events = userInfo.contacts.reversed()
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        NotificationCenter.default.addObserver(self, selector: #selector(onPayload(_:)), name: .payload, object: nil)
    }

    @objc func onPayload(_ notification: Notification)
    {
        events = userInfo.contacts.reversed()
        tableView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var events: [ContactPayload]
    private var tableView: UITableView!
    let clearButton: UIButton = UIButton(type: .system)
    let reScanButton: UIButton = UIButton(type: .system)
    let closeButton: UIButton = UIButton(type: .system)
    private let userInfo = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView.register(ContactPayloadCell.self, forCellReuseIdentifier: "MyCell")
        tableView.rowHeight = 130
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = Colors.blue.uiColor()
        closeButton.titleLabel?.font = Fonts.button.get()
        closeButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        closeButton.setTitle("Close", for: .normal)
        closeButton.layer.cornerRadius = 12
        view.addSubview(closeButton)

        reScanButton.translatesAutoresizingMaskIntoConstraints = false
        reScanButton.backgroundColor = Colors.blue.uiColor()
        reScanButton.titleLabel?.font = Fonts.button.get()
        reScanButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        reScanButton.setTitle("Scan", for: .normal)
        reScanButton.layer.cornerRadius = 12
        view.addSubview(reScanButton)

        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.backgroundColor = Colors.blue.uiColor()
        clearButton.titleLabel?.font = Fonts.button.get()
        clearButton.setTitleColor(Colors.white.uiColor(), for: .normal)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.layer.cornerRadius = 12
        view.addSubview(clearButton)

        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            reScanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            reScanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reScanButton.widthAnchor.constraint(equalToConstant: 100),
            reScanButton.heightAnchor.constraint(equalToConstant: 60),
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        closeButton.addTarget(self,
            action: #selector(handleNextTouchUpInside),
            for: .touchUpInside)

        clearButton.addTarget(self,
            action: #selector(handleClearTouchUpInside),
            for: .touchUpInside)

        reScanButton.addTarget(self,
            action: #selector(handleScanTouchUpInside),
            for: .touchUpInside)

    }

    @objc func handleNextTouchUpInside() {
        self.dismiss(animated: true)
    }

    @objc func handleScanTouchUpInside() {
        NotificationCenter.default.post(name: .reScan, object: nil)
    }

    @objc func handleClearTouchUpInside() {
        userInfo.contacts = [ContactPayload]()
        events = userInfo.contacts.reversed()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(events[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! ContactPayloadCell
        let payload = events[indexPath.item]
        let titleText = payload.received ? "recieved" : "sent"

        cell.titleLabel.text = "Contact Payload: \(titleText)"
        cell.nonceLabel.text = "Nonce: \(payload.nonce)"
        cell.subLabel.text = "Sub: \(payload.sub)"
        cell.audLabel.text = "Aud: \(payload.aud)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        cell.dateLabel.text = "Date: \(dateFormatter.string(from: payload.date))"

        return cell
    }
}
