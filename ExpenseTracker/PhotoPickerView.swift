//
//  PhotoPickerView.swift
//  ExpenseTracker
//
//  Created by Batuhan on 1.09.2023.
//

import SwiftUI

struct PhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var photoData: Data?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let parent: PhotoPickerView
        
        init(parent: PhotoPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            let resizedImage = image?.resized(to: .init(width: 500, height: 500))
            let imageData = resizedImage?.jpegData(compressionQuality: 0.5)
            self.parent.photoData = imageData
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    
    
}
