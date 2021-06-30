//
//  RequestCell.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 13/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class RequestCell: UICollectionViewCell {
    
    let methodLabel: WHLabel = {
        let label = WHLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.textAlignment = .natural
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let codeLabel: WHLabel = {
        let label = WHLabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.cornerRadius = 6.0
        label.padding = 6.0
        label.borderWidth = 0.5
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    let urlLabel: WHLabel = {
        let label = WHLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    let durationLabel: WHLabel = {
        let label = WHLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        }
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .fill
        hStack.spacing = 4.0
        self.contentView.setSubview(subview: hStack, edgeInsets: UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0))

        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .leading
        vStack.spacing = 4.0
        hStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.widthAnchor.constraint(equalToConstant: 80.0).isActive = true

        vStack.addArrangedSubview(methodLabel)
        vStack.addArrangedSubview(codeLabel)
        vStack.addArrangedSubview(durationLabel)

        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(urlLabel)
    }

    func populate(request: RequestModel?){
        guard request != nil else {
            return
        }
        
        methodLabel.text = request?.method.uppercased()
        codeLabel.isHidden = request?.code == 0 ? true : false
        codeLabel.text = request?.code != nil ? String(request!.code) : "-"
        if let code = request?.code{
            var color: UIColor = Colors.HTTPCode.Generic
            switch code {
            case 200..<300:
                color = Colors.HTTPCode.Success
            case 300..<400:
                color = Colors.HTTPCode.Redirect
            case 400..<500:
                color = Colors.HTTPCode.ClientError
            case 500..<600:
                color = Colors.HTTPCode.ServerError
            default:
                color = Colors.HTTPCode.Generic
            }
            codeLabel.borderColor = color
            codeLabel.textColor = color
        }
        else{
            codeLabel.borderColor = Colors.HTTPCode.Generic
            codeLabel.textColor = Colors.HTTPCode.Generic
        }
        urlLabel.text = request?.url
        durationLabel.text = request?.duration?.formattedMilliseconds() ?? ""
    }
}
