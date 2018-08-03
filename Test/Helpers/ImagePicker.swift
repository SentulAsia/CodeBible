//
//  ImagePicker.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

public protocol ImagePickerDelegate: class {
    func imagePickerFinishCapture(successfully flag: Bool, withImage image: UIImage?)
}

public class ImagePicker: NSObject {
    public static let shared = ImagePicker()

    // MARK: Delegate
    public final weak var delegate: ImagePickerDelegate?
    public final var controller: UIViewController? // controller to present the image picker
    public final var imageWidth: CGFloat? // resize image to a specific width

    fileprivate final var imagePicker: UIImagePickerController!

    // MARK: Inherited
    public override init() {
        super.init()
    }

    public static func showMenu(
        sender: UIView,
        controller: UIViewController
    ) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            let camera = ImagePicker.shared
            camera.controller = controller
            camera.delegate = controller as? ImagePickerDelegate
            camera.imageWidth = 200
            camera.takePicture()
        })
        menu.addAction(action1)

        let action2 = UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            let photoLibrary = ImagePicker.shared
            photoLibrary.controller = controller
            photoLibrary.delegate = controller as? ImagePickerDelegate
            photoLibrary.imageWidth = 200
            photoLibrary.selectPicture()
        })
        menu.addAction(action2)

        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            print("Alert Cancelled")
        })
        menu.addAction(action3)

        menu.modalPresentationStyle = UIModalPresentationStyle.popover
        let popPresenter = menu.popoverPresentationController
        popPresenter?.sourceView = sender
        popPresenter?.sourceRect = sender.bounds
        popPresenter?.permittedArrowDirections = UIPopoverArrowDirection.up

        controller.present(menu, animated: true, completion: nil)
    }

    public func selectPicture() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self

        self.controller?.present(self.imagePicker, animated: true, completion: nil)
    }

    public func takePicture() {
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        if UIImagePickerController.isCameraDeviceAvailable(.front) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            self.controller?.present(self.imagePicker, animated: true, completion: {
                CustomPhotoAlbum.sharedInstance.requestAuthorization()
            })
        } else if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .rear
            self.controller?.present(self.imagePicker, animated: true, completion: {
                CustomPhotoAlbum.sharedInstance.requestAuthorization()
            })
        } else {
            noCamera()
        }
    }

    fileprivate func noCamera() {
        setImage(nil)
    }

    fileprivate func setImage(_ image: UIImage?) {
        if let i = image {
            self.delegate?.imagePickerFinishCapture(successfully: true, withImage: i)
        } else {
            self.delegate?.imagePickerFinishCapture(successfully: false, withImage: nil)
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.imagePicker = nil
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage

        if picker.sourceType == .camera {
            if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                CustomPhotoAlbum.sharedInstance.saveImage(possibleImage)
            }
        }

        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad && picker.sourceType == .photoLibrary {
            if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                newImage = possibleImage
            } else {
                self.imagePicker.dismiss(animated: true, completion: nil)
                self.imagePicker = nil
                return
            }
        } else {
            if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                newImage = possibleImage
            } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                newImage = possibleImage
            } else {
                self.imagePicker.dismiss(animated: true, completion: nil)
                self.imagePicker = nil
                return
            }
        }

        // do something interesting here!
        print("image size: \(newImage.size)")

        if let newWidth = self.imageWidth {

            let scale = newWidth / newImage.size.width
            let newHeight = newImage.size.height * scale

            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))

            newImage.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            print("image size: \(newImage.size)")
        }

        setImage(newImage)

        self.imagePicker.dismiss(animated: true, completion: nil)
        self.imagePicker = nil
    }
}
