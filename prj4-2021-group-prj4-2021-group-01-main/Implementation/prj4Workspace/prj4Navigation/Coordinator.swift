//
//  Coordinator.swift
//  prj4Navigation
//
//  Created by Kestutis DIkinis on 21/05/2021.
//

import Foundation
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
    var captureImageViewCor: CaptureImageView
    init(isShown: Binding<Bool>, captureImageView: CaptureImageView) {
    _isCoordinatorShown = isShown
    captureImageViewCor = captureImageView
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
    let imageData: Data = unwrapImage.jpegData(compressionQuality: 0.1)!
    let strBase64 = imageData.base64EncodedString()
    captureImageViewCor.image = strBase64
    isCoordinatorShown = false
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
  }
}
