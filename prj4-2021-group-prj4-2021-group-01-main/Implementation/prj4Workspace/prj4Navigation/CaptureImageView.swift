//
//  CaptureImageView.swift
//  prj4Navigation
//
//  Created by Kestutis DIkinis on 21/05/2021.
//

import Foundation
import SwiftUI

struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: String
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(isShown: $isShown, captureImageView: self)
        }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        //this code enables the taking pictures with a camera functionality
        //picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}
