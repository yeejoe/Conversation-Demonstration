//
//  ChatDetailViewController.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import UIKit
import RxSwift

protocol ChatDetailViewControllerDelegate{
    func updateLatestMessage(conversationIndex: Int, latestMessage: String)
}

class ChatDetailViewController: UIViewController {

    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var messageToSend: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    var viewModel: ChatDetailViewModel?
    
    var disposeBag: DisposeBag?
    var latestMessageDelegate: ChatDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        
        // Do any additional setup after loading the view.
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "OutgoingMessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "out")
        mainTableView.register(UINib(nibName: "IncomingMessageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "in")
        
        viewModel?.messageObservable.subscribe { messageList in
            if messageList.element != nil{
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
        }.disposed(by: disposeBag!)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if (messageToSend.text?.isEmpty ?? true){
            //do nothing
            return
        }
        //otherwise then add new message into the array
        let newMessage = Message()
        newMessage.message = messageToSend.text
        newMessage.direction = "OUTGOING"
        newMessage.timestamp = Date()
        viewModel?.addNewMessage(newMessage: newMessage)
        let lastRow = IndexPath(row: (viewModel?.messageList.count)! - 1, section: 0)
        mainTableView.insertRows(at: [lastRow], with: UITableView.RowAnimation.automatic)
        mainTableView.scrollToRow(at: lastRow, at: UITableView.ScrollPosition.bottom, animated: true)
        messageToSend.text = ""
        
        if let callback = latestMessageDelegate{
            callback.updateLatestMessage(conversationIndex: (viewModel?.conversationId)!, latestMessage: newMessage.message!)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.messageList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = (viewModel?.messageList[indexPath.row])!
        
        if cellData.direction == "OUTGOING"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "out") as! OutgoingMessageTableViewCell
            cell.setView(message: cellData)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "in") as! IncomingMessageTableViewCell
            cell.setView(message: cellData)
            return cell
        }
    }
}
