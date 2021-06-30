//
//  RequestTitleSectionView.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 18/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class RequestTitleSectionView: UITableViewHeaderFooterView {

    let titleLabel: WHLabel = {
        let label = WHLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        contentView.setSubview(subview: titleLabel, edgeInsets: UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0), atIndex: nil)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 12.0).isActive = true
    }
}
