//
//  UIColor+Extension.swift
//  ExpenseTracker
//
//  Created by Batuhan on 4.08.2023.
//

import SwiftUI

extension UIColor {
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    static func decode(from data: Data) -> UIColor? {
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
        }
}
