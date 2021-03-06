/// Copyright © 2018 Zaid M. Said
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

protocol ImagePickerDelegate: class {
    func imagePickerFinishCapture(successfully flag: Bool, withImage image: UIImage?)
}

class ImagePickerController: NSObject {
    static let shared = ImagePickerController()

    // MARK: Delegate
    weak var delegate: ImagePickerDelegate?
    var imageWidth: CGFloat? // resize image to a specific width

    private var imagePicker: UIImagePickerController!

    // MARK: Inherited
    private override init() {
        super.init()
    }

    static func presentMenu(_ sender: UIView, delegate: ImagePickerDelegate) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            let camera = ImagePickerController.shared
            camera.delegate = delegate
            camera.imageWidth = 200
            camera.takePicture()
        })
//        let image1 = #imageLiteral(resourceName: "icons8-camera")
//        action1.setValue(image1, forKey: "image")
//        action1.setValue(0, forKey: "titleTextAlignment")
        menu.addAction(action1)
        let action2 = UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            let photoLibrary = ImagePickerController.shared
            photoLibrary.delegate = delegate
            photoLibrary.imageWidth = 200
            photoLibrary.selectPicture()
        })
//        let image2 = #imageLiteral(resourceName: "icons8-picture")
//        action2.setValue(image2, forKey: "image")
//        action2.setValue(0, forKey: "titleTextAlignment")
        menu.addAction(action2)
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(action3)
        menu.modalPresentationStyle = UIModalPresentationStyle.popover
        let popPresenter = menu.popoverPresentationController
        popPresenter?.sourceView = sender
        popPresenter?.sourceRect = sender.bounds
        popPresenter?.permittedArrowDirections = UIPopoverArrowDirection.up
        (delegate as? UIViewController)?.present(menu, animated: true, completion: nil)
    }

    func selectPicture() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self

        (self.delegate as? UIViewController)?.present(self.imagePicker, animated: true, completion: {
            CustomPhotoAlbum.shared.requestAuthorization()
        })
    }

    func takePicture() {
        self.imagePicker =  UIImagePickerController()
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        if UIImagePickerController.isCameraDeviceAvailable(.front) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            (self.delegate as? UIViewController)?.present(self.imagePicker, animated: true, completion: {
                CustomPhotoAlbum.shared.requestAuthorization()
            })
        } else if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .rear
            (self.delegate as? UIViewController)?.present(self.imagePicker, animated: true, completion: {
                CustomPhotoAlbum.shared.requestAuthorization()
            })
        } else {
            noCamera()
        }
    }

    private func noCamera() {
        setImage(nil)
    }

    private func setImage(_ image: UIImage?) {
        if let i = image {
            self.delegate?.imagePickerFinishCapture(successfully: true, withImage: i)
        } else {
            self.delegate?.imagePickerFinishCapture(successfully: false, withImage: nil)
        }
    }
}

extension ImagePickerController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.imagePicker = nil
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var newImage: UIImage

        if picker.sourceType == .camera {
            if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                CustomPhotoAlbum.shared.saveImage(possibleImage)
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

        Log("image size before: \(newImage.size)")

        if let newWidth = self.imageWidth {

            let scale = newWidth / newImage.size.width
            let newHeight = newImage.size.height * scale

            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))

            newImage.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            Log("image size after: \(newImage.size)")
        }

        setImage(newImage)

        self.imagePicker.dismiss(animated: true) {
            self.imagePicker = nil
        }
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
}
