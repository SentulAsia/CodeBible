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

enum APIMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

enum APIResult {
    case success(Any)
    case failure(APIError)

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

    var error: APIError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

struct APIError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return self.message
    }
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        return self.message
    }

    public var failureReason: String? {
        return self.message
    }
}

struct APIResponse {
    let request: URLRequest?
    let data: Data?
    let response: URLResponse?
    let result: APIResult

    var value: Any? { return self.result.value }
    var error: Error? { return self.result.error }

    init(request: URLRequest?, data: Data?, response: URLResponse?, result: APIResult) {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}

struct APIWorker {
    private init() {}

    static func request(url: URL, method: APIMethod, parameters: [String: Any]?, headers: [String: String]? = nil, body: Data? = nil) throws -> APIResponse {
        var request = URLRequest(url: url)
        var apiResponse: APIResponse?
        var apiError: Error?

        if let p = parameters {
            do {
                if let data = try JSONSerialization.data(withJSONObject: p, options: JSONSerialization.WritingOptions(rawValue: 0)) as Data? {
                    request.httpBody = data
                }
            } catch {
                Log("----------------------------")
                Log("url: ", url.description)
                Log("params: ", parameters ?? "")
                Log("\(url.description) failed")
                Log("response: nil")
                Log("----------------------------")
                throw error
            }
        } else if let data = body {
            request.httpBody = data
        }

        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)

        dispatchQueue.async {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 12.0
            sessionConfig.timeoutIntervalForResource = 60.0
            let sessionManager = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

            if let h = headers {
                for header in h {
                    request.addValue(header.value, forHTTPHeaderField: header.key)
                }
            }
            request.httpMethod = method.rawValue

            let dataTask = sessionManager.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if let e = error {
                    Log("----------------------------")
                    Log("url:", url.description)
                    Log("params:", parameters ?? "")
                    Log("\(url.description) failed")
                    if let httpResponse = response as? HTTPURLResponse {
                        if Environment.isDevelopment {
                            if let d = data, let result = String(data: d, encoding: String.Encoding.utf8) {
                                Log("result:", result)
                            } else {
                                Log("result:", httpResponse.allHeaderFields as? [String: Any] ?? httpResponse)
                            }
                        }
                        Log("status code:", httpResponse.statusCode)
                    }
                    Log("----------------------------")
                    apiError = e
                } else if let d = data {
                    Log("----------------------------")
                    Log("url:", url.description)
                    Log("params:", parameters ?? "")
                    Log("\(url.description) success")
                    if let httpResponse = response as? HTTPURLResponse {
                        if Environment.isDevelopment {
                            if let result = UIImage(data: d) {
                                Log("result:", result.size)
                            } else if let result = String(data: d, encoding: String.Encoding.utf8) {
                                Log("result:", result)
                            } else {
                                Log("result:", httpResponse.allHeaderFields as? [String: Any] ?? httpResponse)
                            }
                        }
                        Log("status code:", httpResponse.statusCode)
                    }
                    Log("----------------------------")
                    let result = APIResult.success(d)
                    apiResponse = APIResponse(request: request, data: data, response: response, result: result)
                } else {
                    Log("----------------------------")
                    Log("url:", url.description)
                    Log("params:", parameters ?? "")
                    Log("\(url.description) failed")
                    if let httpResponse = response as? HTTPURLResponse {
                        Log("result:", httpResponse.allHeaderFields as? [String: Any] ?? httpResponse)
                        Log("status code:", httpResponse.statusCode)
                    }
                    Log("----------------------------")
                    apiError = APIError(Constants.Message.failureDefault)
                }
                semaphore.signal()
            }
            dataTask.resume()
            semaphore.wait()
        }

        if let e = apiError {
            throw e
        } else if let r = apiResponse {
            return r
        }

        throw APIError(Constants.Message.failureDefault)
    }
}

private extension NSError {
    /// Default Error to be thrown (deprecated)
    ///
    /// - returns: default NSError object
    static var `default` = NSError(domain: "", code: 0, userInfo: [
        NSLocalizedDescriptionKey: NSLocalizedString("Error", value: Constants.Message.failureDefault, comment: ""),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", value: Constants.Message.failureDefault, comment: "")
    ])
}
