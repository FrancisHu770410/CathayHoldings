//
//  CHMainViewCell.swift
//  CathayHoldings
//
//  Created by 胡珀菖 on 2021/4/17.
//

import UIKit

class CHMainViewCell: UITableViewCell, CHTableViewCell {
    
    @IBOutlet weak var m_imgPlant: UIImageView!
    @IBOutlet weak var m_lbName: UILabel!
    @IBOutlet weak var m_lbLocation: UILabel!
    @IBOutlet weak var m_lbDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure<T>(_ vm: T) where T : CHTableViewCellModel {
        let vmMain = vm as? CHMainViewCellModel
        m_imgPlant.setImage(vmMain?.imgUrl ?? "")
        m_lbName.text = vmMain?.name
        m_lbLocation.text = vmMain?.location
        m_lbDescription.text = vmMain?.feature
    }
}
