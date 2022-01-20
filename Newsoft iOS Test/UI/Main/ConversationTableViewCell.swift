//
//  ConversationTableViewCell.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var lastMessage: UILabel!
    @IBOutlet var time: UILabel!
    
    var dateFormatter: DateFormatter = DateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(conversation: Conversation){
        name.text = conversation.name
        lastMessage.text = conversation.lastmessage
        if let conDate = conversation.date{
            dateFormatter.dateFormat = "yyyy-MM-dd"
            time.text = dateFormatter.string(from: conDate)
        }else{
            time.text = ""
        }
    }
}
