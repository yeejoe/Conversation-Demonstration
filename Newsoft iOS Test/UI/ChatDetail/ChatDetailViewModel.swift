//
//  ChatDetailViewModel.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import Foundation
import RxSwift

class ChatDetailViewModel{
    var messageObservable: PublishSubject<[Message]> = PublishSubject()
    var conversation: Conversation
    var conversationId: Int
    var messageList: [Message]
    
    init(conversationId: Int, conversation: Conversation) {
        messageList = []
        self.conversation = conversation
        self.conversationId = conversationId
        readMessageFile()
    }
    
    func readMessageFile(){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let fileData = FileUtils.readFileFromBundle(fileName: "message")
            if let mainJson = fileData, let messageMainObject = mainJson as? [String: Any], let messageArray = messageMainObject["chat"] as? [[String:String]]{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                for messageJson in messageArray{
                    let messageObj = Message()
                    messageObj.message = messageJson["message"]
                    messageObj.direction = messageJson["direction"]
                    messageObj.timestamp = dateFormatter.date(from:messageJson["timestamp"] ?? "")
                    self.messageList.append(messageObj)
                }
                
                //publish the latest data to UI
                self.messageObservable.on(.next(self.messageList))
            }
        }
    }
    
    func addNewMessage(newMessage: Message){
        messageList.append(newMessage)
    }
}
