//
//  ActionableTableViewCell.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 10/07/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class ActionableTableViewCell: UITableViewCell {

    let labelAction: WHLabel = {
        let label = WHLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        self.contentView.setSubview(subview: labelAction, edgeInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0), atIndex: nil)
        labelAction.heightAnchor.constraint(greaterThanOrEqualToConstant: 20.0).isActive = true
    }
}
