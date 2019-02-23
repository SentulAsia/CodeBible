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

protocol FileManagerHelper: FileManagerDirectoryNames {
    @discardableResult func createFile(containing: AnyObject, to path: FileManagerDirectories, withName name: String) -> Bool
    @discardableResult func readFile(at path: FileManagerDirectories, withName name: String) -> AnyObject?
    @discardableResult func deleteFile(at path: FileManagerDirectories, withName name: String) -> Bool
    @discardableResult func renameFile(at path: FileManagerDirectories, with oldName: String, to newName: String) -> Bool
    @discardableResult func moveFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool
    @discardableResult func copyFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool
    @discardableResult func changeFileExtension(withName name: String, inDirectory: FileManagerDirectories, toNewExtension newExtension: String) -> Bool
}

extension FileManagerHelper {
    @discardableResult
    func createFile(containing: AnyObject, to path: FileManagerDirectories, withName name: String) -> Bool {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data?
        switch containing {
        case is Bool:
            rawData = (containing as? Bool)?.data
        case is Int:
            rawData = (containing as? Int)?.data
        case is Decimal:
            rawData = (containing as? Decimal)?.data
        case is Float:
            rawData = (containing as? Float)?.data
        case is Double:
            rawData = (containing as? Double)?.data
        case is String:
            rawData = (containing as? String)?.data
        case is UIImage:
            rawData = (containing as? UIImage)?.data
        case is Data:
            rawData = containing as? Data
        default:
            print("FileManagerHelper: invalid data type")
            return false
        }
        if let r = rawData {
            return FileManager.default.createFile(atPath: filePath, contents: r, attributes: nil)
        }
        
        return false
    }
    
    @discardableResult
    func readFile(at path: FileManagerDirectories, withName name: String) -> AnyObject? {
        let filePath = getURL(for: path).path + "/" + name
        if let fileContents = FileManager.default.contents(atPath: filePath) {
            if let fileContentsAsImage = UIImage(data: fileContents) {
                return fileContentsAsImage as AnyObject
            } else if let fileContentsAsString = String(data: fileContents) {
                return fileContentsAsString as AnyObject
            } else if let fileContentsAsDouble = Double(data: fileContents) {
                return fileContentsAsDouble as AnyObject
            } else if let fileContentsAsFloat = Float(data: fileContents) {
                return fileContentsAsFloat as AnyObject
            } else if let fileContentsAsDecimal = Decimal(data: fileContents) {
                return fileContentsAsDecimal as AnyObject
            } else if let fileContentsAsInt = Int(data: fileContents) {
                return fileContentsAsInt as AnyObject
            } else if let fileContentsAsBool = Bool(data: fileContents) {
                return fileContentsAsBool as AnyObject
            } else {
                return fileContents as AnyObject
            }
        }
        
        return nil
    }
    
    @discardableResult
    func deleteFile(at path: FileManagerDirectories, withName name: String) -> Bool {
        let filePath = buildFullPath(forFileName: name, inDirectory: path)
        if let _ = try? FileManager.default.removeItem(at: filePath) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    func renameFile(at path: FileManagerDirectories, with oldName: String, to newName: String) -> Bool {
        let oldPath = getURL(for: path).appendingPathComponent(oldName)
        let newPath = getURL(for: path).appendingPathComponent(newName)
        if let _ = try? FileManager.default.moveItem(at: oldPath, to: newPath) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    func moveFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name, inDirectory: directory)
        if let _ = try? FileManager.default.moveItem(at: originURL, to: destinationURL) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    func copyFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool {
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: name+"1", inDirectory: directory)
        if let _ = try? FileManager.default.copyItem(at: originURL, to: destinationURL) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    func changeFileExtension(withName name: String, inDirectory: FileManagerDirectories, toNewExtension newExtension: String) -> Bool {
        var newFileName = NSString(string:name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName:String =  String(newFileName)
        
        let originURL = buildFullPath(forFileName: name, inDirectory: inDirectory)
        let destinationURL = buildFullPath(forFileName: finalFileName, inDirectory: inDirectory)
        
        if let _ = try? FileManager.default.moveItem(at: originURL, to: destinationURL) {
            return true
        }
        
        return false
    }
}

fileprivate protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}

fileprivate extension DataConvertible {
    init?(data: Data) {
        guard data.count == MemoryLayout<Self>.size else { return nil }
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

extension Bool: DataConvertible {}
extension Int: DataConvertible {}
extension Float: DataConvertible {}
extension Double: DataConvertible {}
extension Decimal: DataConvertible {}

extension String: DataConvertible {
    init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }
    var data: Data {
        if let utf8 = self.data(using: .utf8) {
            return utf8
        }
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

extension UIImage: DataConvertible {
    var data: Data {
        if let pngData = self.pngData() {
            return pngData
        } else if let jpegData = self.jpegData(compressionQuality: 1.0) {
            return jpegData
        }
        return withUnsafeBytes(of: self) { Data($0) }
    }
}
