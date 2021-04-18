//
//  MVVMExtension.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import UIKit

@objc protocol CHActivityIndicatorViewModel {
    @objc dynamic var isLoading: Bool { get set }
}

@objc protocol CHTableViewModel {
    @objc dynamic var aryViewModel: [CHTableViewCellModel] { get set }
}

@objc protocol CHTableViewCellModel {
    func onClick()
}

protocol CHTableViewCell {
    func configure<T>(_ vm: T) where T : CHTableViewCellModel
}

extension UIView {
    
    private struct pOV {
        static var ob: NSKeyValueObservation? = nil
    }
    
    var ob: NSKeyValueObservation? {
        get {
            guard let kvo = objc_getAssociatedObject(self, &pOV.ob) as? NSKeyValueObservation else {
                return nil
            }
            return kvo
        }
        set {
            objc_setAssociatedObject(self, &pOV.ob, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}

extension UIActivityIndicatorView {
    
    func bind<T>(_ vm: T) where T: NSObject, T: CHActivityIndicatorViewModel {
        ob = vm.observe(\.isLoading, options: .new) { [unowned self] (model, newValue) in
            (newValue.newValue ?? false) ? startAnimating() : stopAnimating()
        }
    }
}

extension UITableView {
    
    func bind<T>(_ vm: T) where T: NSObject, T: CHTableViewModel {
        ob = vm.observe(\.aryViewModel, options: .new) { [unowned self] (model, newValue) in
            reloadData()
        }
    }
}
