//
//  CHZooPlantWS.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

typealias CHGetZooPlantSuccessClosure = (_ response: CHGetZooPlantResultListResponse) -> Swift.Void

struct CHGetZooPlantRequest: Encodable {
    let scope: String = "resourceAquire"
    let rid: String = "f18de02f-b6c9-47c0-8cda-50efad621c14"
    let limit: Int
    let offset: Int
}

struct CHGetZooPlantResultResponse: Decodable {
    let F_Name_Ch: String
    let F_Location: String
    let F_Feature: String
    let F_Pic01_URL: String
}

typealias CHGetZooPlantResultListResponse = [CHGetZooPlantResultResponse]

extension CHWebServiceManager {
    
    func getZooPlant(request: CHGetZooPlantRequest, success: @escaping CHGetZooPlantSuccessClosure, failure: @escaping CHWebServiceFailureClosure) {
        
        operate(urlPath: .openData,
                urlParams: [],
                method: .GET,
                request: request,
                response: CHGetZooPlantResultListResponse.self,
                successClosure: { (response) in
            
                    success(response ?? [])
            
        }, failureClosure: failure)
    }
    
}
