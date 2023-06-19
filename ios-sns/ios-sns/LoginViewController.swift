//
//  LoginViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var userId: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func SignInButton(_ sender: Any) {
        
        db.collection("users").whereField("id", isEqualTo: userId.text!)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.isEmpty{
                        let alert = UIAlertController(title: "로그인실패", message: "일치하는 id가 없습니다", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default){ action in
                            self.userId.text = ""
                            self.userPassword.text = ""
                        })
                        self.present(alert, animated: true, completion: nil)
                    }
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if document.data()["password"] as! String == self.userPassword.text!{
                            UserDefaults.standard.set(document.data()["id"] as! String, forKey: "id")
                            UserDefaults.standard.set(document.data()["nickName"] as! String, forKey: "nickName")
                            UserDefaults.standard.set(document.documentID, forKey: "ref")
                            guard let tabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarViewController else {
                                return
                            }
                            self.navigationController?.pushViewController(tabBarViewController, animated: true)
                        }else{
                            let alert = UIAlertController(title: "로그인실패", message: "비밀번호가 일치하지 않습니다", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default){ action in
                                self.userId.text = ""
                                self.userPassword.text = ""
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        
    }

}
