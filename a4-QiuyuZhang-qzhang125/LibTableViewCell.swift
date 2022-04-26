//
//  LibTableViewCell.swift
//  a4-QiuyuZhang-qzhang125
//
//  Created by Qiuyu Zhang on 2022-04-05.
//

import UIKit

class LibTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBookName: UILabel!
    
    @IBOutlet weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
