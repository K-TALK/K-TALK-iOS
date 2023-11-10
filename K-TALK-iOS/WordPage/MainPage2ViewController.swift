//
//  MainPage2ViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/03.
//

import UIKit


class MainPage2ViewController: UIViewController {
    var wordData: [WordData] = []
    var filteredWord: [WordData] = []
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var wordTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        wordData = loadWordDataFromJSON()
        setUpSearchController()
        wordTable.dataSource = self
        wordTable.delegate = self
    }

    private func setUpSearchController() {
        wordTable.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search Word"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
    }

    func showDetailScreen(selectedWord: WordData) {
        guard let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailViewController.selectedWord = selectedWord
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let destinationViewController = segue.destination as? DetailViewController {
                if let indexPath = wordTable.indexPathForSelectedRow {
                    let selectedWord = searchController.isActive ? filteredWord[indexPath.row] : wordData[indexPath.row]
                    destinationViewController.selectedWord = selectedWord
                    destinationViewController.modalPresentationStyle = .fullScreen
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
             self.view.endEditing(true)
    }
}

extension MainPage2ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wordTable.dequeueReusableCell(withIdentifier: "wordTableCell", for: indexPath) as! wordTableViewCell
        let word: WordData
        if searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) {
            word = filteredWord[indexPath.row]
        } else {
            word = wordData[indexPath.row]
        }
        cell.korean.text = word.단어
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedWord = searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) ? filteredWord[indexPath.row] : wordData[indexPath.row]
        showDetailScreen(selectedWord: selectedWord)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) ? filteredWord.count : wordData.count
    }
}

extension MainPage2ViewController: UISearchResultsUpdating {
    func filteredContentForSearchText(_ searchText: String) {
        filteredWord = wordData.filter { $0.단어.lowercased().contains(searchText.lowercased()) }
        wordTable.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text ?? "")
    }
}
