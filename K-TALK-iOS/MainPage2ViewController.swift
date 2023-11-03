//
//  MainPage2ViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/03.
//

import UIKit

class MainPage2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Auto layout, variables, and unit scale are not yet supported
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 396, height: 198)
        var shadows = UIView()
        shadows.frame = view.frame
        shadows.clipsToBounds = false
        view.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 18)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 4
        layer0.shadowOffset = CGSize(width: 0, height: 4)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        var shapes = UIView()
        shapes.frame = view.frame
        shapes.clipsToBounds = true
        view.addSubview(shapes)

        let layer1 = CALayer()
        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer1.bounds = shapes.bounds
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)

        shapes.layer.cornerRadius = 18

        var parent = self.view!
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 396).isActive = true
        view.heightAnchor.constraint(equalToConstant: 198).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16).isActive = true
        view.topAnchor.constraint(equalTo: parent.topAnchor, constant: 630).isActive = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
