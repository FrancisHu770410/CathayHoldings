//
//  CHWebServiceManager.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

class CHWebServiceManager {
    static let shared : CHWebServiceManager = CHWebServiceManager()
    
    var runningTasks: [URLSessionDataTask] = []
    
    let encoder = JSONEncoder()
    
    let decoder = JSONDecoder()
    
    private var headerFields: [String : String] {
        
        return ["Content-Type" : "application/json"]
    }
        
    func operate<T,E>(urlPath: CHWebServicePath,
                      urlParams: [String],
                      method: CHHttpMethod,
                      request: T,
                      response: E.Type,
                      successClosure: @escaping CHWebServiceCompleteClosure<E>,
                      failureClosure: @escaping CHWebServiceFailureClosure) where T: Encodable, E: Decodable {
        
        guard let urlRequest = generateRequest(urlPath: urlPath,
                                               urlParams: urlParams,
                                               method: method,
                                               request: request) else {
            failureClosure(CHError.exception())
            return
        }
                
        let task = URLSession.shared.dataTask(with: urlRequest) { [unowned self] (data, urlResponse, error) in
            DispatchQueue.main.async {
                                
                if let currentTask = runningTasks.filter({$0.originalRequest == urlRequest}).first {
                    removeTask(dataTask: currentTask)
                }
                
                if let httpError = guardHttpError(error: error, urlResponse: urlResponse) {
                    failureClosure(httpError)
                    return
                }
                
                guard let d = data, let response = decodeResponse(responseTarget: CHResponse<E>.self, data: d) else {
                    failureClosure(CHError.exception())
                    return
                }
            
                successClosure(response.result.results)
            }
        }
        
        operateTask(dataTask: task)
    }
}

extension CHWebServiceManager {
    
    fileprivate func generateRequest<T: Encodable>(urlPath: CHWebServicePath,
                                       urlParams: [String],
                                       method: CHHttpMethod,
                                       request: T) -> URLRequest? {
        
        var strUrl = kWebServiceUri + urlPath.rawValue
                
        if method == .GET {
            
            if false == urlParams.isEmpty {
                let params = urlParams.joined(separator: "/")
                strUrl += "/\(params)"
            }
            
            guard let reqJson = try? encoder.encode(request) else {
                
                return nil
            }
            
            guard let dicReq = try? JSONSerialization.jsonObject(with: reqJson, options: []) as? [String: Any] else {
                
                return nil
            }
            
            let queryItems = dicReq.keys.map({ URLQueryItem(name: $0, value: String(describing: dicReq[$0] ?? "")) })
            
            guard var urlComponents = URLComponents(string: strUrl) else { return nil }
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else { return nil }
            
            return URLRequest(url: url,
                              method: method,
                              header: headerFields,
                              body: nil)
        }
        else if method == .POST
        {
            if false == urlParams.isEmpty {
                let params = urlParams.joined(separator: "/")
                strUrl += "/\(params)"
            }
        }
        
        guard let url = URL(string: strUrl) else { return nil }
        
        return URLRequest(url: url,
                          method: method,
                          header: headerFields,
                          body: encodeRequest(req: request))
    }
    
    fileprivate func encodeRequest<T: Encodable>(req: T) -> Data? {
        
        guard let reqJson = try? encoder.encode(req) else {
            
            return nil
        }
        
        return reqJson
    }
    
    fileprivate func decodeResponse<E>(responseTarget: CHResponse<E>.Type, data: Data) -> CHResponse<E>? where E: Decodable {
        
        guard let response = try? decoder.decode(responseTarget, from: data) else {
            
            return nil
        }
        
        return response
    }
}

extension CHWebServiceManager {
    
    internal func operateTask(dataTask: URLSessionDataTask) {
        runningTasks.append(dataTask)
        
        dataTask.resume()
    }
    
    func removeTask(dataTask: URLSessionDataTask) {
        if let idx = runningTasks.firstIndex(of: dataTask) {
            runningTasks.remove(at: idx)
        }
    }
    
    private func operateTasks(operation: CHWebServiceTaskOperation) {
        runningTasks.forEach({operation($0)})
    }
    
    func resumeAll() {
        operateTasks(operation: {$0.resume()})
    }
    
    func suspendAll() {
        operateTasks(operation: {$0.suspend()})
    }
    
    func cancelAll() {
        operateTasks(operation: {$0.cancel()})
        
        runningTasks = []
    }
}

extension CHWebServiceManager {
    
    fileprivate func guardHttpError(error: Error?, urlResponse: URLResponse?) -> CHError? {
        
        guard nil == error else {
            return CHError(code: error!.code,
                           description: error!.webServiceErrorDescription)
        }
        
        guard (urlResponse as? HTTPURLResponse)?.statusCode == kHttpSuccessCode else {
            return CHError.exception()
        }
        
        return nil
    }
}
