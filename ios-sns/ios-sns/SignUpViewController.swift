//
//  SignUpViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class SignUpViewController: UIViewController {

    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var userNickName: UITextField!
    
    @IBOutlet weak var userId: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userPasswordCheck: UITextField!
    
    let db = Firestore.firestore()
    
    // 회원가입 버튼 클릭시
    @IBAction func SignUpButton(_ sender: Any) {
        
        // 성공일때 alert
        let alert = UIAlertController(title: "환영합니다", message: "회원가입이 성공적으로 완료되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            self.navigationController?.pushViewController(loginViewController, animated: true)
        })
        
        
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "id" : userId.text!,
            "nickName": userNickName.text!,
            "password" : userPassword.text!,
            "friends":[]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.present(alert, animated: true, completion: nil)
            }
        }
    
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height / 2
        // Do any additional setup after loading the view.
    }

}
