//
//  ProfileViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var myProfileImg: UIImageView!
    
    @IBOutlet weak var myPostTableView: UITableView!
    
    @IBAction func EditButton(_ sender: UIButton) {
        if myPostTableView.isEditing == true{
            myPostTableView.isEditing = false
            sender.setTitle("게시물 편집", for: .normal)
        }else{
            myPostTableView.isEditing = true
            sender.setTitle("완료", for: .normal)
        }

    }
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

        // Do any additional setup after loading the view.
        myProfileImg.layer.cornerRadius = myProfileImg.frame.height / 2
        
        
        self.myPostTableView.rowHeight = UITableView.automaticDimension
        self.myPostTableView.estimatedRowHeight = 120
        
        
        self.myPostTableView.delegate = self
        self.myPostTableView.dataSource = self
        self.myPostTableView.isEditing = false
    }
    
}

extension ProfileViewController: UITableViewDataSource{
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray.count
    }
    
    // 각 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "MyPostTableViewCell", for: indexPath) as! MyPostTableViewCell
        
        cell.myContentLabel.text = contentArray[indexPath.row]
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }

}
