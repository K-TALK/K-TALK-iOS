//
//  File.swift
//  K-TALK-iOS
//
//  Created by 박세인 on 2023/11/09.
//

import Foundation
import UIKit

class EducationMainViewController: UIViewController{
    @IBOutlet weak var backMain: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func moveMainPage(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
