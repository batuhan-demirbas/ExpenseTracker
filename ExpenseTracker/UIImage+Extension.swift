//
//  UIImage+Extension.swift
//  ExpenseTracker
//
//  Created by Batuhan on 7.09.2023.
//

import SwiftUI

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: size))
        
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage
        }
        
        return nil
    }
}
