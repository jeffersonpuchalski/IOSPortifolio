//
//  HomeVC.swift
//  IOSPortifolio
//
//  Created by Jefferson Puchalski on 18/04/20.
//  Copyright © 2020 Jefferson Puchalski. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: ViewController {
    //MARK: - Variables
    var homeViewModel: HomeViewModel = HomeViewModel()
    var repoList = [RepositoryResponse]()
    @StorageCodable(key: "userInfo", defaultValue: UserResponse())
    var userInfo: UserResponse
    
    //MARK: - IBOutlets
    @IBOutlet weak var headInfoView: UserInfoView!
    @IBOutlet weak var repositoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repositoryTableView.delegate = self
        self.repositoryTableView.dataSource = self
        
     let headView = UINib(nibName: "UserInfo", bundle:Bundle.main).instantiate(withOwner: self, options: nil).first as! UserInfoView
          
        headView.setup(userName: userInfo.login ?? "", fullName: userInfo.name ?? "")
        self.headInfoView.addSubview(headView)
        
        let url = URL(string:userInfo.avatarUrl ?? "")
        let processor = DownsamplingImageProcessor(size: headView.portraitImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
        headView.portraitImageView.kf.indicatorType = .activity
        headView.portraitImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic_Octo"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeViewModel.getUserRepos { result in
            switch result {
            case .success(let userRepo):
                DispatchQueue.main.async {
                    self.repoList = userRepo
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
