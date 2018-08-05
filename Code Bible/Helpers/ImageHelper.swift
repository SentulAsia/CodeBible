//
//  ImageHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 05/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

extension UIImage {
    var base64EncodedString: String {
        return UIImageJPEGRepresentation(self, 1.0)!.base64EncodedString(options: .lineLength64Characters)
    }
}

extension String {
    var base64DecodedImage: UIImage? {
        if let dataDecoded: Data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            if let image = UIImage(data: dataDecoded) {
                return image
            }
        }
        return nil
    }
}
