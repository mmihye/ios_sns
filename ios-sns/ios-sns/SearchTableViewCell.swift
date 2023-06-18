//
//  SearchTableViewCell.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/18.
//
import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell{
    
    @IBOutlet weak var userProfileImg: UIImageView!
    
    // 쎌이 렌더링 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height / 2
    }
    
}
