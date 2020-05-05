//
//  ContactPayloadCell.swift
//  ContactTracer
//
//  Created by Leigh Williams on 2020-04-07.
//  Copyright © 2020 Identos. All rights reserved.
//

import Foundation
import UIKit

class ContactPayloadCell: UITableViewCell {

    let titleLabel = UILabel(frame: .zero)
    let nonceLabel = UILabel(frame: .zero)
    let subLabel = UILabel(frame: .zero)
    let audLabel = UILabel(frame: .zero)
    let dateLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Contact Payload"
        titleLabel.font = Fonts.normalBold.get()
        titleLabel.textColor = Colors.blue.uiColor()
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        nonceLabel.translatesAutoresizingMaskIntoConstraints = false
        nonceLabel.text = "Nonce: "
        nonceLabel.font = Fonts.normalMedium.get()
        nonceLabel.textAlignment = .left
        contentView.addSubview(nonceLabel)
        
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.text = "Sub: "
        subLabel.font = Fonts.normalMedium.get()
        subLabel.textAlignment = .left
        contentView.addSubview(subLabel)
        
        audLabel.translatesAutoresizingMaskIntoConstraints = false
        audLabel.text = "Aud: "
        audLabel.font = Fonts.normalMedium.get()
        audLabel.textAlignment = .left
        contentView.addSubview(audLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = "Date: "
        dateLabel.font = Fonts.normalMedium.get()
        dateLabel.textAlignment = .left
        contentView.addSubview(dateLabel)
        
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.2);
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nonceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            nonceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nonceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subLabel.topAnchor.constraint(equalTo: nonceLabel.bottomAnchor, constant: 5),
            subLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            audLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 5),
            audLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            audLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: audLabel.bottomAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
