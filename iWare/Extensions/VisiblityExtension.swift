//
//  VisiblityExtension.swift
//  iWare
//
//  Created by admin on 26/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
}
