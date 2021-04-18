//
//  CHMainViewModel.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Foundation

let kMainViewPageCount: Int = 20

final class CHMainViewCellModel: NSObject, CHTableViewCellModel {
    let imgUrl: String
    let name: String
    let location: String
    let feature: String
    
    init(imgUrl: String,
         name: String,
         location: String,
         feature: String) {
        
        self.imgUrl = imgUrl
        self.name = name
        self.location = location
        self.feature = feature
    }
    
    func onClick() {
        let model = CHMainViewDetailModel(imgUrl: imgUrl,
                                          name: name,
                                          location: location,
                                          feature: feature)
        let vc = CHMainDetailViewController(model: model)
        CHUtility.present(vc, animated: true, completion: nil)
    }
}

final class CHMainViewModel: NSObject, CHActivityIndicatorViewModel, CHTableViewModel {
            
    @objc dynamic var isLoading: Bool = false
    
    @objc dynamic var aryViewModel: [CHTableViewCellModel] = []
    
    func inquiryData() {
        guard false == isLoading else {
            return
        }

        isLoading = true
        let request = CHGetZooPlantRequest(limit: kMainViewPageCount,
                                           offset: aryViewModel.count)
        
        CHWebServiceManager.shared.getZooPlant(request: request) { [unowned self] (response) in
            
            isLoading = false
            aryViewModel += response.cellModels()
            
        } failure: { [unowned self] (error) in
            
            isLoading = false
            CHUtility.showRemind(msg: error.description)
            
        }
    }
}

extension CHGetZooPlantResultListResponse {
    func cellModels() -> [CHMainViewCellModel] {
        return map({ CHMainViewCellModel(imgUrl: $0.F_Pic01_URL,
                                         name: $0.F_Name_Ch,
                                         location: $0.F_Location,
                                         feature: $0.F_Feature) })
    }
}
