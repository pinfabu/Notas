//
//  CGColorExtension.swift
//  Notas
//
//  Created by Juan Carlos Díaz Valenzuela on 20/04/24.
//

import Foundation
import UIKit

public extension CGColor {
    var UIColor : UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}
