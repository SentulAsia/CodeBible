//
//  APIRequest.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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
