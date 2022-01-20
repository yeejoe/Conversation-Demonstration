//
//  MainViewModel.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import Foundation
import RxSwift

class MainViewModel{
    let conversationObserver: PublishSubject<[Conversation]> = PublishSubject<[Conversation]>()
    var conversationList: [Conversation]
    var backupConversationList: [Conversation]
    
    init() {
        conversationList = []
        backupConversationList = []
        readConversationFile()
    }
    
    func readConversationFile(){
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let fileData = FileUtils.readFileFromBundle(fileName: "conversation")
            if let mainJson = fileData, let conversationsArray = mainJson as? [[String: String]]{
                let dateFormatter = DateFormatter()
//                2021-08-16T02:08:13.126Z
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                for conversationJson in conversationsArray{
                    let conversationObj = Conversation()
                    conversationObj.date = dateFormatter.date(from:conversationJson["date"] ?? "")
                    if conversationObj.date == nil{
                        continue
                    }
                    conversationObj.name = conversationJson["name"]
                    conversationObj.lastmessage = conversationJson["lastmessage"]
                    self.conversationList.append(conversationObj)
                }
                
                self.conversationList.sort { c1, c2 in
                
                    if c1.date != nil && c2.date != nil{
                        return c1.date!.compare(c2.date!) == .orderedDescending
                    }else{
                        return true
                    }
                }
                
                self.backupConversationList.append(contentsOf: self.conversationList)
                //publish the latest data to UI
                self.conversationObserver.on(.next(self.conversationList))
            }
        }
    }
    
    func updateLatestConversationLatestMessage(index: Int, message: String){
        self.conversationList[index].lastmessage = message
        self.conversationObserver.on(.next(self.conversationList))
    }
    
    func filterWithText(text: String?){
        if text != nil{
            self.conversationList = self.conversationList.filter { c in
                let check1 = c.name?.contains(text!) ?? false
                let check2 = c.lastmessage?.contains(text!) ?? false
                return check1 || check2
            }
            self.conversationObserver.on(.next(self.conversationList))
        }else{
            self.conversationList.removeAll()
            self.conversationList.append(contentsOf: self.backupConversationList)
            self.conversationObserver.on(.next(self.conversationList))
        }
    }
}
