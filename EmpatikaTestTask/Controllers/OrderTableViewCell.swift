//
//  OrderTableViewCell.swift
//  EmpatikaTestTask
//
//  Created by Михаил on 10.06.16.
//  Copyright © 2016 Mihail. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var deliveryView: UIImageView!
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
