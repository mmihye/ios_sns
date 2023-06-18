//
//  SearchViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/18.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.searchTableView.rowHeight = UITableView.automaticDimension
        self.searchTableView.estimatedRowHeight = 120
        
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
    }
    
}

extension SearchViewController: UITableViewDataSource{
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // 각 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
//        cell.userContentLabel.text = contentArray[indexPath.row]
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate{
    
}
