//
//  UIImageViewExtension.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import Kingfisher

extension UIImageView {
    func setImage(_ url: String, placeholder: UIImage? = nil) {
        
        kf.setImage(with: URL(string: url),
                    placeholder: placeholder,
                    options: [.cacheMemoryOnly,
                              .fromMemoryCacheOrRefresh],
                    progressBlock: nil,
                    completionHandler: nil)
    }
}
