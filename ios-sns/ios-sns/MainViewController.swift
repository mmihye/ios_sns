//
//  MainViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet weak var postTableView: UITableView!
    
    let contentArray = [
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자",
        "나는 말하는 감자"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션 바 숨김
        self.navigationController?.isNavigationBarHidden = true
        
        self.postTableView.rowHeight = UITableView.automaticDimension
        self.postTableView.estimatedRowHeight = 120
        
        
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        
    }
    
}

extension MainViewController: UITableViewDataSource{
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray.count
    }
    
    // 각 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        cell.userContentLabel.text = contentArray[indexPath.row]
        
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate{
    
}
