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

import Foundation

enum APIMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum APIResult {
    case success(Any)
    case failure(Error)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }

    var value: Any? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

struct APIResponse {
    let request: URLRequest?
    let data: Data?
    let response: URLResponse?
    let result: APIResult

    var value: Any? { return self.result.value }
    var error: Error? { return self.result.error }

    init(
        request: URLRequest?,
        data: Data?,
        response: URLResponse?,
        result: APIResult)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}

struct APIRequest {
    static let shared = APIRequest()

    private init() {}

    static func request(
        url: URL,
        method: APIMethod,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completionHandler: @escaping (_ response: APIResponse) -> Void
    ) {
        var request = URLRequest(url: url)
        if let h = headers {
            for header in h {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        request.httpMethod = method.rawValue

        if let p = parameters {
            do {
                if let data = try JSONSerialization.data(withJSONObject: p, options: JSONSerialization.WritingOptions(rawValue: 0)) as Data? {
                    request.httpBody = data
                }
            } catch {
                let result = APIResult.failure(error)
                let r = APIResponse(request: request, data: nil, response: nil, result: result)
                completionHandler(r)
                return
            }
        }

        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let e = error {
                let result = APIResult.failure(e)
                let r = APIResponse(request: request, data: data, response: response, result: result)
                DispatchQueue.main.async {
                    completionHandler(r)
                    return
                }
            } else {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if !responseDictionary.isEmpty {
                            let result = APIResult.success(responseDictionary as Any)
                            let r = APIResponse(request: request, data: data, response: response, result: result)
                            DispatchQueue.main.async {
                                completionHandler(r)
                                return
                            }
                        } else {
                            let e = NSError(domain: "", code: 0, userInfo: [
                                NSLocalizedDescriptionKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "") ,
                                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "")
                                ])
                            let result = APIResult.failure(e)
                            let r = APIResponse(request: request, data: data, response: response, result: result)
                            DispatchQueue.main.async {
                                completionHandler(r)
                                return
                            }
                        }
                    } else {
                        let e = NSError(domain: "", code: 0, userInfo: [
                            NSLocalizedDescriptionKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "") ,
                            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "")
                            ])
                        let result = APIResult.failure(e)
                        let r = APIResponse(request: request, data: data, response: response, result: result)
                        DispatchQueue.main.async {
                            completionHandler(r)
                            return
                        }
                    }
                } catch {
                    let result = APIResult.failure(error)
                    let r = APIResponse(request: request, data: data, response: response, result: result)
                    DispatchQueue.main.async {
                        completionHandler(r)
                        return
                    }
                }
            }
        }
        dataTask.resume()
    }
}
