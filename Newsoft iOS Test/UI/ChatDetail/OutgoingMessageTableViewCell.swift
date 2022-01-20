//
//  OutgoingMessageTableViewCell.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import UIKit

class OutgoingMessageTableViewCell: UITableViewCell {

    @IBOutlet var bubbleView: UIView!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    var dateFormatter: DateFormatter = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFormatter.dateFormat = "HH:mm"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(message: Message){
        messageLbl.text = message.message
        bubbleView.layer.borderWidth = 1
        bubbleView.layer.borderColor = UIColor.systemGray2.cgColor
        bubbleView.layer.cornerRadius = 16
        timeLbl.text = dateFormatter.string(from: message.timestamp!)
    }
}
