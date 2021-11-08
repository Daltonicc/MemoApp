//
//  MainViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/08.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.backgroundColor = .black
        
        topViewSetting()


    }
    
    // MARK: - Method

    func topViewSetting() {
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        textFieldInsideSearchBar?.backgroundColor = .systemGray
        
    }

}

// MARK: - Extension: TableView

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .darkGray
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "고정된 메모" : "메모"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        header.textLabel?.textAlignment = .left

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //회색표시 없애기
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


// MARK: - Extension: SearchBar

extension MainViewController: UISearchBarDelegate {
    
    
}



/* 해결해야 할 부분들
 
1. 섹션 헤더의 좌측 마진값을 없애고 싶은데 아직 해결못함.

 
 
 
 
 
 
 
 
 //자꾸 0번째 섹션의 헤더가 잘리게 나와서 만들어준 헤더 뷰. 없으면 헤더가 잘려서 안보인다. 스크롤해야 보임. -> heightForHeaderInSection메서드로 해결.
//        let headerView = UIView()
//        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 40)
//        headerView.backgroundColor = .black
//
//        memoTableView.tableHeaderView = heade
*/
