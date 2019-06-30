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

struct APIWorker {
    private init() {}

    static func request(url: URL, method: APIMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, body: Data? = nil) throws -> APIResponse {
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
