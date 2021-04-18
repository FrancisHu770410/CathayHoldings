//
//  ErrorExtension.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

extension Error {
    var code: Int {
        return (self as NSError).code
    }
    
    var webServiceErrorDescription: String {
        if self.code == NSURLErrorTimedOut {
            
            return "Request Timed Out"
            
        } else if self.code == NSURLErrorNotConnectedToInternet ||
                  self.code == NSURLErrorNetworkConnectionLost {
            
            return "Please Check Network"
            
        } else {
            
            return CHError.exception().description
        }
    }
}
