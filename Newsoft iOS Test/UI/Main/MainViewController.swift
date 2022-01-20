//
//  MainViewController.swift
//  Newsoft iOS Test
//
//  Created by Joe on 20/01/2022.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var loadMax: Int = 10
    var viewModel: MainViewModel?
    var disposeBag: DisposeBag?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        viewModel = MainViewModel()
        viewModel?.conversationObserver.subscribe({ newConversationList in
            if (newConversationList.element != nil){
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            }
        }).disposed(by: disposeBag!)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "normal")
        
        searchBar.delegate = self
        
        updateSearchView()
    }
    

    @IBAction func searchButtonPressed(_ sender: Any) {
        isSearching = !isSearching
        updateSearchView()
        if !isSearching{
            viewModel?.filterWithText(text: nil)
        }
    }
    
    func updateSearchView(){
        searchBar.isHidden = !isSearching
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ChatDetailViewController, let ip = sender as? IndexPath{
            let cellData = (viewModel?.conversationList[ip.row])!
            let vm = ChatDetailViewModel(conversationId: ip.row, conversation: cellData)
            destination.viewModel = vm
            destination.latestMessageDelegate = self
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return min((viewModel?.conversationList.count ?? 0), loadMax)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal") as! ConversationTableViewCell
        let cellData = (viewModel?.conversationList[indexPath.row])!
        cell.setView(conversation: cellData)
        if indexPath.row % 3 == 0{
            cell.profilePicture.image = UIImage(named: "profile_male")
        }else if indexPath.row % 3 == 1{
            cell.profilePicture.image = UIImage(named: "profile_female")
        }else if indexPath.row % 3 == 2{
            cell.profilePicture.image = UIImage(named: "profile_system")
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) {
            loadMax += 5
            self.mainTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension MainViewController: ChatDetailViewControllerDelegate{
    func updateLatestMessage(conversationIndex: Int, latestMessage: String) {
        self.viewModel?.updateLatestConversationLatestMessage(index: conversationIndex, message: latestMessage)
    }
}

extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel?.filterWithText(text: searchText == "" ? nil : searchText)
    }
}
