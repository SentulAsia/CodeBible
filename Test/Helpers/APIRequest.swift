//
//  APIRequest.swift
//  Test
//
//  Created by Zaid M. Said on 19/07/2018.
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

class APIRequest: NSObject {
    static let shared = APIRequest()

    private override init() {}

    func request(
        url: URL,
        method: APIMethod,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completionHandler: @escaping (APIResponse) -> Void)
    {
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
                let response = APIResponse(request: request, data: nil, response: nil, result: result)
                completionHandler(response)
                return
            }
        }

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                let result = APIResult.failure(e)
                let response = APIResponse(request: request, data: data, response: response, result: result)
                DispatchQueue.main.async {
                    completionHandler(response)
                    return
                }
            } else {
                do {
                    if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if !responseDictionary.isEmpty {
                            let result = APIResult.success(responseDictionary as Any)
                            let response = APIResponse(request: request, data: data, response: response, result: result)
                            DispatchQueue.main.async {
                                completionHandler(response)
                                return
                            }
                        } else {
                            let e = NSError(domain: "", code: 0, userInfo: [
                                NSLocalizedDescriptionKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "") ,
                                NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "")
                                ])
                            let result = APIResult.failure(e)
                            let response = APIResponse(request: request, data: data, response: response, result: result)
                            DispatchQueue.main.async {
                                completionHandler(response)
                                return
                            }
                        }
                    } else {
                        let e = NSError(domain: "", code: 0, userInfo: [
                            NSLocalizedDescriptionKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "") ,
                            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Error", value: Constant.Message.failureDefault, comment: "")
                            ])
                        let result = APIResult.failure(e)
                        let response = APIResponse(request: request, data: data, response: response, result: result)
                        DispatchQueue.main.async {
                            completionHandler(response)
                            return
                        }
                    }
                } catch {
                    let result = APIResult.failure(error)
                    let response = APIResponse(request: request, data: data, response: response, result: result)
                    DispatchQueue.main.async {
                        completionHandler(response)
                        return
                    }
                }
            }
        }
        dataTask.resume()
    }
}
