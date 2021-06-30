//
//  TextTableViewCell.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 17/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    let textView: WHTextView = {
        let label = WHTextView()
        if #available(iOS 10.0, *) {
            label.textContentType = .none
            label.autocapitalizationType = .sentences
        }
        label.isEditable = false
        label.isSelectable = true
        label.isScrollEnabled = false
        label.font = UIFont.systemFont(ofSize: 14)
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
        self.contentView.setSubview(subview: textView, edgeInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0), atIndex: nil)
    }
}
