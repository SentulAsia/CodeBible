/// Copyright (c) 2018 Zaid M. Said
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
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct Channel {
    var isSuccess: Bool
    var message: String
    var code: String
    var channelId: Int
    var channelTitle: String
    var channelStbNumber: Int

    init(
        channelId: Int = 0,
        channelTitle: String = "",
        channelStbNumber: Int = 0
    ) {
        self.isSuccess = false
        self.message = ""
        self.code = ""
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.channelStbNumber = channelStbNumber
    }

    // Parse dictionary to get channel properties
    mutating func parseChannel(dictionary: [String: Any]) {
        if let channelId = dictionary["channelId"] as? Int {
            self.channelId = channelId
        }
        if let channelTitle = dictionary["channelTitle"] as? String {
            self.channelTitle = channelTitle
        }
        if let channelStbNumber = dictionary["channelStbNumber"] as? Int {
            self.channelStbNumber = channelStbNumber
        }
    }

    // Parse dictionary to get channel array
    mutating func parseGetChannelList(dictionary: [String: Any]) -> [Channel] {
        var channelModelObj = Channel()
        var channelModelArrayObj: [Channel] = []

        if let message = dictionary["responseMessage"] as? String, message == "Success" {
            self.isSuccess = true
            self.message = message

            if let code = dictionary["responseCode"] as? String {
                self.code = code
            }

            if let list = dictionary["channels"] as? [Any] {
                if list.count > 0 {
                    for index in 0..<list.count {
                        if let dictionary = list[index] as? [String: Any] {
                            channelModelObj.parseChannel(dictionary: dictionary)
                            channelModelArrayObj.append(channelModelObj)
                        }
                    }
                }
            }
        } else {
            self.isSuccess = false
            if let message = dictionary["responseMessage"] as? String {
                self.message = message
            } else {
                self.message = Constant.Message.failureDefault
            }
        }
        return channelModelArrayObj
    }
}
