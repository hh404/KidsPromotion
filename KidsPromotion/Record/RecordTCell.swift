//
//  RecordTCell.swift
//  KidsPromotion
//
//  Created by huangjianwu on 2020/9/10.
//  Copyright © 2020 huangjianwu. All rights reserved.
//

import UIKit

class RecordTCell: UITableViewCell {
    lazy private var eventLogoImageView = UIImageView(frame: .zero)
    lazy private var eventNameLabel = UILabel(frame: .zero)
    lazy private var dateLabel = UILabel(frame: .zero)
    lazy private var checkboxBtn = UIButton(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(eventLogoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
