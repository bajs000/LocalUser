//
//  SenderCell.swift
//  LocalUser
//
//  Created by 果儿 on 17/1/5.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit
import SDWebImage

class SenderCell: UITableViewCell {

    @IBOutlet weak var progressLineWidth: NSLayoutConstraint!
    @IBOutlet weak var avatarIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var orderState1: UILabel!
    @IBOutlet weak var orderState2: UILabel!
    @IBOutlet weak var orderState3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 11...13 {
            self.viewWithTag(10)?.viewWithTag(i)?.layer.cornerRadius = 3
        }
    }
    
    func fillData(_ dic:NSDictionary) -> Void {
        self.avatarIcon.sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["head_graphic"] as! String)), placeholderImage: UIImage(named: "order-default-sender"))
        self.avatarIcon.layer.cornerRadius = 26.5
        self.nameLabel.text = dic["user_name"] as? String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
