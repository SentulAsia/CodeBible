//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

protocol FileManagerHelper: FileManagerDirectoryNames {
    @discardableResult func createFile(containing value: Any, to path: FileManagerDirectories, withName name: String) -> Bool
    @discardableResult func readFile(at path: FileManagerDirectories, withName name: String) -> Any?
    @discardableResult func deleteFile(at path: FileManagerDirectories, withName name: String) -> Bool
    @discardableResult func renameFile(at path: FileManagerDirectories, with oldName: String, to newName: String) -> Bool
    @discardableResult func moveFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool
    @discardableResult func copyFile(withName name: String, inDirectory: FileManagerDirectories, toDirectory directory: FileManagerDirectories) -> Bool
    @discardableResult func changeFileExtension(withName name: String, inDirectory: FileManagerDirectories, toNewExtension newExtension: String) -> Bool
}

extension FileManagerHelper {
    @discardableResult
    func createFile(containing value: Any, to path: FileManagerDirectories, withName name: String) -> Bool {
        let filePath = getURL(for: path).path + "/" + name
        let rawData: Data?
        switch value {
        case is Bool:
            rawData = (value as? Bool)?.data
        case is Int:
            rawData = (value as? Int)?.data
        case is Decimal:
            rawData = (value as? Decimal)?.data
        case is Float:
            rawData = (value as? Float)?.data
        case is Double:
            rawData = (value as? Double)?.data
        case is String:
            rawData = (value as? String)?.data
        case is UIImage:
            rawData = (value as? UIImage)?.data
        case is Data:
            rawData = value as? Data
        default:
            Log("FileManagerHelper: invalid data type")
            return false
        }
        if let r = rawData {
            return FileManager.default.createFile(atPath: filePath, contents: r, attributes: nil)
        }
        
        return false
    }
    
    @discardableResult
    func readFile(at path: FileManagerDirectories, withName name: String) -> Any? {
        let filePath = getURL(for: path).path + "/" + name
        if let fileContents = FileManager.default.contents(atPath: filePath) {
            if let fileContentsAsImage = UIImage(data: fileContents) {
                return fileContentsAsImage
            } else if let fileContentsAsString = String(data: fileContents) {
                return fileContentsAsString
            } else if let fileContentsAsDouble = Double(data: fileContents) {
                return fileContentsAsDouble
            } else if let fileContentsAsFloat = Float(data: fileContents) {
                return fileContentsAsFloat
            } else if let fileContentsAsDecimal = Decimal(data: fileContents) {
                return fileContentsAsDecimal
            } else if let fileContentsAsInt = Int(data: fileContents) {
                return fileContentsAsInt
            } else if let fileContentsAsBool = Bool(data: fileContents) {
                return fileContentsAsBool
            } else {
                return fileContents
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
        let destinationURL = buildFullPath(forFileName: name + "1", inDirectory: directory)
        if let _ = try? FileManager.default.copyItem(at: originURL, to: destinationURL) {
            return true
        }
        
        return false
    }
    
    @discardableResult
    func changeFileExtension(withName name: String, inDirectory: FileManagerDirectories, toNewExtension newExtension: String) -> Bool {
        var newFileName = NSString(string: name)
        newFileName = newFileName.deletingPathExtension as NSString
        newFileName = (newFileName.appendingPathExtension(newExtension) as NSString?)!
        let finalFileName: String = newFileName as String
        
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

extension DataConvertible {
    var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}

fileprivate extension DataConvertible where Self: ExpressibleByIntegerLiteral {
    init?(data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        self = value
    }
}

extension Int: DataConvertible {}
extension Float: DataConvertible {}
extension Double: DataConvertible {}
extension Decimal: DataConvertible {}

extension Bool: DataConvertible {
    init?(data: Data) {
        guard data.count == MemoryLayout<Bool>.size else { return nil }
        self = data.withUnsafeBytes { $0.load(as: Bool.self) }
    }
}

extension UInt16: DataConvertible {
    init?(data: Data) {
        guard data.count == MemoryLayout<UInt16>.size else { return nil }
        self = data.withUnsafeBytes { $0.load(as: UInt16.self) }
    }
    
    var data: Data {
        var value = CFSwapInt16HostToBig(self)
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

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
        }
        return withUnsafeBytes(of: self) { Data($0) }
    }
}
