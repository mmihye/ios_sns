//
//  MainViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


public struct Post: Codable {

    let text:String
    let id: String
    let NickName: String
    let date:String

}

class MainViewController: UIViewController {
    let db = Firestore.firestore()
    var friendList: Array<String> = []
    
    @IBOutlet weak var postTableView: UITableView!
    
    var friendArray:Array<User> = []
    var contentArray:Array<Post> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 숨김
        self.navigationController?.isNavigationBarHidden = true
        
        let group = DispatchGroup()

        // 친구목록 가져오기
        db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let friends = data["friends"] as? Array<String> {
                        self.friendList = friends
                        print(self.friendList.count)
                        if self.friendList.count > 0 {
                            for friend in self.friendList {
                                group.enter()

                                self.db.collection("users").whereField("nickName", isEqualTo: friend).getDocuments { (querySnapshot, err) in
                                    defer {
                                        group.leave()
                                    }

                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            print("\(document.documentID) => \(document.data())")
                                            let id = document.data()["id"] as! String
                                            let nickName = document.data()["nickName"] as! String

                                            group.enter()

                                            self.db.collection("users").document(document.documentID).collection("posts").getDocuments { (querySnapshot, error) in
                                                defer {
                                                    group.leave()
                                                }

                                                if let error = error {
                                                    print("Error getting documents: \(error)")
                                                } else {
                                                    for document in querySnapshot!.documents {
                                                        print("\(document.documentID) => \(document.data())")
                                                        let post = Post(text: document.data()["text"] as! String,
                                                                        id: id,
                                                                        NickName: nickName,
                                                                        date: document.data()["date"] as! String)
                                                        self.contentArray.append(post)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            group.notify(queue: .main) {
                                // Perform your synchronous tasks here, such as configuring the table view
                                print(self.contentArray)
                                self.postTableView.rowHeight = UITableView.automaticDimension
                                self.postTableView.estimatedRowHeight = 120

                                self.postTableView.delegate = self
                                self.postTableView.dataSource = self

                                // Reload the table view data
                                self.postTableView.reloadData()
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }


            
    }
        
    
}
    
    extension MainViewController: UITableViewDataSource{
        // 테이블 뷰 쎌의 갯수
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(contentArray.count)
            return self.contentArray.count
        }
        
        // 각 쎌에 대한 설정
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            
            cell.userContentLabel.text = contentArray[indexPath.row].text
            cell.userId.text = "@"+contentArray[indexPath.row].id
            cell.userNickname.text = contentArray[indexPath.row].NickName
            cell.userPostDate.text = contentArray[indexPath.row].date
            
            return cell
        }
        
    }
    
    extension MainViewController: UITableViewDelegate{
        
    }

