//
//  DataCell.swift
//  HandleCSVFile
//
//  Created by Artur Daylidonis on 18/5/20.
//  Copyright © 2020 Artur Daylidonis. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
