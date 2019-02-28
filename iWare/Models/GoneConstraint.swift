//
//  GoneConstraint.swift
//  iWare
//
//  Created by admin on 26/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class GoneConstraint {
    private var constraint: NSLayoutConstraint
    private let prevConstant: CGFloat
    
    init(constraint: NSLayoutConstraint) {
        self.constraint = constraint
        self.prevConstant = constraint.constant
    }
    
    func revert() {
        self.constraint.constant = self.prevConstant
    }
}


fileprivate struct AssociatedKeys {
    static var widthGoneConstraint: UInt8 = 0
    static var heightGoneConstraint: UInt8 = 0
}


@IBDesignable
extension UIView {
    
    @IBInspectable
    var gone: Bool {
        get {
            return !self.isHidden
        }
        set {
            update(gone: newValue)
        }
    }
    
    weak var widthConstraint: GoneConstraint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.heightGoneConstraint) as? GoneConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.widthGoneConstraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    weak var heightConstraint: GoneConstraint? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.heightGoneConstraint) as? GoneConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.heightGoneConstraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func update(gone: Bool) {
        isHidden = gone
        if gone {
            for constr in self.constraints {
                if constr.firstAttribute == NSLayoutConstraint.Attribute.width {
                    self.widthConstraint = GoneConstraint(constraint: constr)
                }
                if constr.firstAttribute == NSLayoutConstraint.Attribute.height {
                    self.heightConstraint = GoneConstraint(constraint: constr)
                }
                constr.constant = 0
            }
        } else {
            widthConstraint?.revert()
            heightConstraint?.revert()
        }
    }
}
