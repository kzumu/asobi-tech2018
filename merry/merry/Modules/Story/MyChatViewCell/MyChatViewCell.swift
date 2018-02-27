//
//  MyChatViewCell.swift
//  lime
//
//  Created by 下村一将 on 2017/10/25.
//  Copyright © 2017 kazu. All rights reserved.
//

import UIKit

class MyChatViewCell: UITableViewCell {
	
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var readLabel: UILabel!
	
	@IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.backgroundColor = UIColor.clear
		self.textView.layer.cornerRadius = 15
		addSubview(MyBalloonView(frame: CGRect(x: Int(frame.size.width+30), y: 0, width: 30, height: 30)))
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}

extension MyChatViewCell {
	func updateCell(text: String, time: String, isRead: Bool) {
		self.textView?.text = text
		self.timeLabel?.text = time
		self.readLabel?.isHidden = !isRead
		
		let frame = CGSize(width: self.frame.width - 8, height: CGFloat.greatestFiniteMagnitude)
		var rect = self.textView.sizeThatFits(frame)
		if(rect.width<30){
			rect.width=30
		}
		textViewWidthConstraint.constant = rect.width
	}
}
