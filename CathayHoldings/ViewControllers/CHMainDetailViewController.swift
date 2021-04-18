//
//  CHMainDetailViewController.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/18.
//

import UIKit

class CHMainDetailViewController: UIViewController {

    @IBOutlet weak var m_imgPlant: UIImageView!
    @IBOutlet weak var m_tvInfo: UITextView!
    
    private var m_info: CHMainViewDetailModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    private func initView() {
        
        m_imgPlant.setImage(m_info.imgUrl)
        
        m_tvInfo.text = "植物名稱：\(m_info.name)\n植物地點：\(m_info.location)\n植物說明：\(m_info.feature)"
    }

    required init(model: CHMainViewDetailModel) {
        super.init(nibName: "CHMainDetailViewController", bundle: nil)
        m_info = model
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
