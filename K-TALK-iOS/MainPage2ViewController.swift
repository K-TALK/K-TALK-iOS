//
//  MainPage2ViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/03.
//

import UIKit

class MainPage2ViewController: UIViewController {
    var wordData : [WordData] = []
    @IBOutlet weak var wordTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        wordData = loadWordDataFromJSON()
        wordTable.dataSource = self
        // Auto layout, variables, and unit scale are not yet supported
    }
    let kWord = ["사과", "배", "딸기","포도"]

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainPage2ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordTable.dequeueReusableCell(withIdentifier: "wordTableCell", for: indexPath) as! wordTableViewCell
        let word = wordData[indexPath.row]
        cell.korean.text = word.단어
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordData.count
    }
    
}
