//
//  HistoryTableViewCell.swift
//  final
//
//  Created by Jasper Lin on 2019/6/23.
//  Copyright © 2019 jasperlin1996. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBOutlet weak var historylabel: UILabel!
    @IBOutlet weak var historyImage: UIImageView!
}
