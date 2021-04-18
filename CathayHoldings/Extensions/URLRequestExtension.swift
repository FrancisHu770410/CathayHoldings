//
//  URLRequestExtension.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

extension URLRequest {
    init(url: URL, method: CHHttpMethod, header: [String: String]?, body: Data?) {
        
        self.init(url: url,
                  cachePolicy: .reloadIgnoringLocalCacheData,
                  timeoutInterval: kTimeoutInterval_WS)
        
        self.allHTTPHeaderFields = header
        self.httpMethod = method.rawValue
        self.httpBody = body
    }
}
