//
//  ImagePickerCoordinator.swift
//  PhotoDemo
//
//  Created by Łukasz Andrzejewski on 30/05/2023.


import Foundation
import UIKit
import SwiftUI

final class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    var imagePickerView: ImagePickerView
    
    init(imagePickerView: ImagePickerView) {
        self.imagePickerView = imagePickerView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        imagePickerView.selectedImage = image
        imagePickerView.isPresented.wrappedValue.dismiss()
    }
    
}
