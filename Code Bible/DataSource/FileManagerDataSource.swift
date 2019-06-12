/// Copyright © 2019 Zaid M. Said
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

fileprivate extension Constants {
    static let sample = "Profile.png"
}

struct FileManagerDataSource: FileManagerHelper, FileManagerSystemMetaData {
    static var shared = FileManagerDataSource()
    
    private init() {}
    
    var profileImage: UIImage? {
        get {
            return getObject(withName: Constants.sample) as? UIImage
        }
        set {
            setObject(newValue, withName: Constants.sample)
        }
    }
    
    func deleteAll(forDirectory directory: FileManagerDirectories) {
        if let files = list(directory: getURL(for: directory)) {
            for file in files {
                deleteFile(at: .Documents, withName: file)
            }
        }
    }
}

private extension FileManagerDataSource {
    func getObject(withName name: String) -> Any? {
        if let object = readFile(at: .Documents, withName: name) {
            return object
        }
        return nil
    }
    
    func setObject(_ object: Any?, withName name: String) {
        if let o = object {
            createFile(containing: o, to: .Documents, withName: name)
        } else {
            deleteFile(at: .Documents, withName: name)
        }
    }
}
