//
//  CircleUiView.swift
//  iWare
//
//  Created by admin on 04/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}
