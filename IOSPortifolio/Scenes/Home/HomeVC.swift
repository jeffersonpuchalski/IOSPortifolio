//
//  HomeVC.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 18/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit

class HomeVC: ViewController {
    //MARK: - Variables
    var homeViewModel: HomeViewModel = HomeViewModel()
    var repoList = [RepositoryResponse]()

    
    //MARK: - IBOutlets
    @IBOutlet weak var repositoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repositoryTableView.delegate = self
        self.repositoryTableView.dataSource = self.repoList as? UITableViewDataSource
        self.homeViewModel.getUserRepos { result in
            switch result {
            case .success(let userRepo):
                DispatchQueue.main.async {
                    self.repoList = userRepo!
                    self.repositoryTableView.reloadData()
                }
                break
                
            case .failure(let error):
                AlertDialogManager.ShowError(error, self)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as! UserRepoCell
        
        // Set contente from cell
        cell.setup(repoName: self.repoList[indexPath.row].name ?? "", owner: self.repoList[indexPath.row].full_name ?? "")
        
        return cell
        
    }
}
