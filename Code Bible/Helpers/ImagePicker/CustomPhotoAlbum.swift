//
//  CustomPhotoAlbum.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Photos

class CustomPhotoAlbum {
    static let albumName = Constant.appName
    static let shared = CustomPhotoAlbum()

    var assetCollection: PHAssetCollection!

    init() {
        func fetchAssetCollectionForAlbum() -> PHAssetCollection! {

            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

            if let firstObject: AnyObject = collection.firstObject {
                return firstObject as! PHAssetCollection
            }

            return nil
        }

        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = fetchAssetCollectionForAlbum()
            }
        }
    }

    func saveImage(
        _ image: UIImage
    ) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            if self.assetCollection == nil {
                assertionFailure("there was an error upstream, skip the save")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                albumChangeRequest!.addAssets([assetPlaceHolder!] as NSFastEnumeration)
            }, completionHandler: nil)
        }
    }

    func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                print("status: \(status)")
            })
        }
    }
}
