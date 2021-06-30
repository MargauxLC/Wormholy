//
//  File.swift
//  
//
//  Created by pac on 30/06/2021.
//

import UIKit

extension UIView {
    public func setSubview(subview: UIView, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, atIndex index: Int? = nil) {
        removeSubviews()
        addSubviewAndSetupMargins(subview: subview, margins: edgeInsets, atIndex: index)
    }

    public func addSubviewAndSetupMargins(subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero, atIndex index: Int? = nil) {
        if let index = index {
            insertSubview(subview, at: index)
        } else {
            addSubview(subview)
        }

        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "H:|-(\(margins.left))-[view]-(\(margins.right))-|",
                        metrics: nil,
                        views: ["view": subview]))
        addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|-(\(margins.top))-[view]-(\(margins.bottom))-|",
                        metrics: nil,
                        views: ["view": subview]))
    }

    public func addSubviewAndSetupMarginsInSafeArea(subview: UIView, margins: UIEdgeInsets = UIEdgeInsets.zero, atIndex index: Int? = nil) {
        if let index = index {
            insertSubview(subview, at: index)
        } else {
            addSubview(subview)
        }

        subview.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = pinnedConstraintInSafeArea(subview: subview, attribute: .top, margin: margins.top)
        let trailingConstraint = pinnedConstraintInSafeArea(subview: subview, attribute: .trailing, margin: margins.right)
        let bottomConstraint = pinnedConstraintInSafeArea(subview: subview, attribute: .bottom, margin: margins.bottom)
        let leadingConstraint = pinnedConstraintInSafeArea(subview: subview, attribute: .leading, margin: margins.left)

        addConstraints([topConstraint, trailingConstraint, bottomConstraint, leadingConstraint])
    }

    private func pinnedConstraintInSafeArea(subview: UIView,
                                            attribute: NSLayoutConstraint.Attribute,
                                            margin: CGFloat = 0) -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return NSLayoutConstraint(item: subview,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: self.safeAreaLayoutGuide,
                                      attribute: attribute,
                                      multiplier: 1,
                                      constant: margin)
        } else {
            return NSLayoutConstraint()
        }
    }

    public func addCenteredSubview(_ subview: UIView, size: CGSize? = nil) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        if let size = size {
            NSLayoutConstraint.activate([
                subview.centerXAnchor.constraint(equalTo: centerXAnchor),
                subview.centerYAnchor.constraint(equalTo: centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: size.width),
                subview.heightAnchor.constraint(equalToConstant: size.height)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.centerXAnchor.constraint(equalTo: centerXAnchor),
                subview.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    public func removeSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
