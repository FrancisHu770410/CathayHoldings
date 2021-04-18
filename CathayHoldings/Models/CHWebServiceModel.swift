//
//  CHWebServiceModel.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

let kTimeoutInterval_WS: TimeInterval = 30.0
let kHttpSuccessCode: Int = 200

let kWebServiceUri: String = "https://data.taipei/"

typealias CHWebServiceCompleteClosure<E> = (_ response: E?) -> ()
typealias CHWebServiceFailureClosure = (_ error: CHError) -> ()
typealias CHWebServiceTaskOperation = (URLSessionDataTask) -> Swift.Void

enum CHWebServicePath: String {
    case openData = "opendata/datalist/apiAccess"
}

enum CHHttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

class CHResponse<T:Decodable>: Decodable {
    let result: CHResultResponse<T>
}

class CHResultResponse<T:Decodable>: Decodable {
    
    var limit: Int?
    
    var offset: Int?
    
    var count: Int?
    
    var sort: String?

    var results: T?
    
    private enum CodingKeys: String, CodingKey {
        case limit
        case offset
        case count
        case sort
        case results
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try? container.decode(Int.self, forKey: .limit)
        offset = try? container.decode(Int.self, forKey: .offset)
        count = try? container.decode(Int.self, forKey: .count)
        sort = try? container.decode(String.self, forKey: .sort)
        results = try? container.decode(T.self, forKey: .results)
    }
}

struct CHError {
    var code: Int
    var description: String
    
    static func exception() -> CHError {
        return CHError(code: -999, description: "unknown error")
    }
}
