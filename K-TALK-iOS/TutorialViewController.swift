//
//  ViewController.swift
//  K-TALK-iOS
//
//  Created by JungGue LEE on 2023/10/24/13.
//

import UIKit

class TutorialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pageInfo()
        leftButton.isEnabled = false
    }
    @IBOutlet weak var TutoImage: UIImageView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var pageLabel: UILabel!
    var imageList = [
        "1.png",
        "2.png",
        "3.png",
        "4.png"
    ]
    var currentPage = 0
    @IBAction func doLeft(_ sender: Any) {
        currentPage = currentPage - 1
        if currentPage < 0 {
            currentPage = imageList.count - 1
        }
        
        // 활성화/비활성화 여부를 설정합니다.
        leftButton.isEnabled = (currentPage != 0)
        rightButton.isEnabled = true // right 버튼은 항상 활성화합니다.
        
        print("left ", imageList[currentPage], imageList.count)
        pageInfo()
    }

    @IBAction func doRight(_ sender: Any) {
        currentPage = currentPage + 1
        if currentPage >= imageList.count {
            currentPage = 0
        }
        
        // 활성화/비활성화 여부를 설정합니다.
        rightButton.isEnabled = (currentPage != imageList.count - 1)
        leftButton.isEnabled = true // left 버튼은 항상 활성화합니다.
        
        print("right ", imageList[currentPage], imageList.count)
        pageInfo()
    }

    func pageInfo(){
        let pageInfo = String(format: " %d / %d", currentPage + 1, imageList.count)
        pageLabel.text = pageInfo
        self.showImage(imageName: imageList[currentPage])
    }
    func showImage(imageName: String) {
        if let image = UIImage(named: imageName) {
            TutoImage.image = image
        } else {
            print("이미지를 찾을 수 없음: \(imageName)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openLoginView(_ sender: Any) {
      
    }
}

