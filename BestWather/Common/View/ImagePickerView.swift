//
//  ImagePickerView.swift
//  PhotoDemo
//
//  Created by Łukasz Andrzejewski on 30/05/2023.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    typealias Coordinator = ImagePickerCoordinator
    
    @Environment(\.presentationMode) var isPresented
    @Binding var selectedImage: UIImage?
    var source: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = source
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        ImagePickerCoordinator(imagePickerView: self)
    }
    
}
