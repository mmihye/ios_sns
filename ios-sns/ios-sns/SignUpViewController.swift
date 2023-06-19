//
//  SignUpViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase


class SignUpViewController: UIViewController {

    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var userNickName: UITextField!
    
    @IBOutlet weak var userId: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userPasswordCheck: UITextField!
    
    let db = Firestore.firestore()
    
    // 회원가입 버튼 클릭시
    @IBAction func SignUpButton(_ sender: Any) {
        
        if userPassword.text == userPasswordCheck.text {
            // 성공일때 alert
            let alert = UIAlertController(title: "환영합니다", message: "회원가입이 성공적으로 완료되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                    return
                }
                self.navigationController?.pushViewController(loginViewController, animated: true)
            })
            
            FirebaseStorageManager.uploadImage(image: userProfileImg.image!, pathRoot: userNickName.text!) { url in
                if let url = url {
                    
                    // Add a new document with a generated id.
                    var ref: DocumentReference? = nil
                    ref = self.db.collection("users").addDocument(data: [
                        "id" : self.userId.text!,
                        "nickName": self.userNickName.text!,
                        "password" : self.userPassword.text!,
                        "friends":[],
                        "profileImg": url.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "회원가입 실패", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) {_ in
                self.userPassword.text = ""
                self.userPasswordCheck.text = ""
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        
    
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height / 2
        // Do any additional setup after loading the view.
    }

}

extension SignUpViewController{
    @IBAction func addProfileButton(_ sender: Any) {
        // 컨트로러를 생성한다
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self // 이 딜리게이터를 설정하면 사진을 찍은후 호출된다

        imagePickerController.sourceType = .photoLibrary

        present(imagePickerController, animated: true, completion: nil)
    }

}

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // 사진을 찍은 경우 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        userProfileImg.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }

    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}
