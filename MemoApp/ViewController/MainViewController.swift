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
        
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.backgroundColor = .black
        
        
        topViewSetting()

    }
    
    
    
    // MARK: - Method

    func topViewSetting() {
        
        view.backgroundColor = .darkGray
        
        let searchController = UISearchController(searchResultsController: nil)
        let insideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        
        insideSearchBar?.textColor = .white
        insideSearchBar?.backgroundColor = .systemGray
        
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "N개의 메모"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "메모", style: .plain, target: nil, action: nil)
    }

}

// MARK: - Extension(TableView)

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 5 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .darkGray
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //회색표시 없애기
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel()
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 25)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false


        if section == 0 {
            sectionLabel.text = "고정된 메모"
            let _ = headerView.safeAreaLayoutGuide // 이유는 알 수 없지만 해당 상수를 넣지 않으면 처음에는 헤더가 존재하나 스크롤 했다가 돌아오면 헤더가 사라져버린다;

            headerView.bounds = headerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
            headerView.addSubview(sectionLabel)

            return headerView

        } else {
            sectionLabel.text = "메모"
            let _ = headerView.safeAreaLayoutGuide // 위에 거랑 얘 둘다 없애면 헤더 두 개다 사라짐. 쓰지도 않는데 왜사라지지
                        
            headerView.bounds = headerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
            headerView.addSubview(sectionLabel)
            
            return headerView
        }
    }
}

/* 해결해야 할 부분들
 
1. 섹션 헤더의 좌측 마진값을 없애고 싶은데 아직 해결못함. -> 해결 viewForHeaderInSection 메서드 이용. 헤더뷰를 따로 만들어줌.
    헤더뷰 위에 마진값 줘야함.
2. 셀과 셀사이 보더 왼쪽 마진 때문에 보더라인이 끊겨 있다.
3. 0번째 섹션의 헤더가 네비게이션바와 너무 붙어있음. -> 헤더의 높이를 가능한 높인 다음, 헤더뷰 내부 패딩값을 줘서 해결
 
 
 //자꾸 0번째 섹션의 헤더가 잘리게 나와서 만들어준 헤더 뷰. 없으면 헤더가 잘려서 안보인다. 스크롤해야 보임. -> heightForHeaderInSection메서드로 해결.

*/
