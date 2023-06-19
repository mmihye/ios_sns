//
//  SearchViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/18.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

public struct User: Codable {

    let id: String
    let NickName: String
    let profileImg:String

}

class SearchViewController: UIViewController {
    let db = Firestore.firestore()
    

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchTableView: UITableView!

    var contentArray:Array<User> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Create a DispatchGroup
        let group = DispatchGroup()

        // Enter the DispatchGroup before the Firestore operation
        group.enter()
        
        self.contentArray.removeAll()
        db.collection("users").getDocuments { (querySnapshot, error) in
            defer {
                // Leave the DispatchGroup when the Firestore operation completes
                group.leave()
            }

            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if document.documentID != UserDefaults.standard.string(forKey: "ref") {
                        let user = User(id: document.data()["id"] as! String, NickName: document.data()["nickName"] as! String, profileImg: document.data()["profileImg"] as! String)
                        self.contentArray.append(user)
                    } else {
                        print("내껀 패스")
                    }

                }
            }
        }

        // Notify the DispatchGroup when all asynchronous tasks are complete
        group.notify(queue: .main) {
            // Perform your synchronous tasks here, such as configuring the table view
            self.searchTableView.rowHeight = UITableView.automaticDimension
            self.searchTableView.estimatedRowHeight = 120

            self.searchTableView.delegate = self
            self.searchTableView.dataSource = self

            // Reload the table view data
            self.searchTableView.reloadData()
        }

    
        
    }
    
}

extension SearchViewController {
    @IBAction func searchButton(_ sender: Any) {
        self.contentArray.removeAll()
        let text = self.searchText.text!
        
        db.collection("users").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let nickName = document.data()["nickName"] as! String
                    let id = document.data()["id"] as! String
                    if (nickName.contains(text) ||  id.contains(text) || text == "") {
                        let user = User(id: id, NickName: nickName, profileImg: document.data()["profileImg"] as! String)
                        self.contentArray.append(user)
                    }
                }
                
                DispatchQueue.main.async {
                    // UI 업데이트를 수행하는 메서드를 호출합니다.
                    self.searchTableView.reloadData() // 예시: 테이블 뷰를 다시 로드하여 데이터를 반영합니다.
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource{
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentArray.count
    }
    
    // 각 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.userNickname.text = contentArray[indexPath.row].NickName
        cell.userId.text = "@"+contentArray[indexPath.row].id
        FirebaseStorageManager.downloadImage(urlString: contentArray[indexPath.row].profileImg) { [weak self] image in
                cell.userProfileImg.image = image
            }
        
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate{
    
}

