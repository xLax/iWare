//
//  RemoveElementArray.swift
//  iWare
//
//  Created by admin on 05/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = index(of: object) else {return}
        remove(at: index)
    }
    
}
