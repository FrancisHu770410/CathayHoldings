//
//  CHUtility.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import UIKit

class CHUtility {
    
    static func getTopViewController() -> UIViewController? {
        var topViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
    
    static func showRemind(msg: String) {
        let alert = UIAlertController(title: "系統訊息", message: msg, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "確認", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirm)
        
        CHUtility.present(alert, animated: true, completion: nil)
    }
    
    static func present(_ vc: UIViewController, animated: Bool, completion: (() -> ())?) {
        CHUtility.getTopViewController()?.present(vc, animated: animated, completion: completion)
    }
}
