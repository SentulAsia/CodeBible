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

import Foundation

protocol AppFileSystemMetaData {
    func list(directory at: URL) -> Bool
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any]
}

extension AppFileSystemMetaData {
    func list(directory at: URL) -> Bool {
        let listing = try! FileManager.default.contentsOfDirectory(atPath: at.path)
        
        if listing.count > 0 {
            print("\n----------------------------")
            print("LISTING: \(at.path)")
            print("")
            for file in listing {
                print("File: \(file.debugDescription)")
            }
            print("")
            print("----------------------------\n")
            
            return true
        } else {
            return false
        }
    }
    
    func attributes(ofFile atFullPath: URL) -> [FileAttributeKey : Any] {
        return try! FileManager.default.attributesOfItem(atPath: atFullPath.path)
    }
}