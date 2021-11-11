//
//  MainViewController.swift
//  MemoApp
//
//  Created by 박근보 on 2021/11/08.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    let localRealm = try! Realm()
    var memoList: Results<MemoList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topViewSetting()
        memoTableView.backgroundColor = .black
        memoList = localRealm.objects(MemoList.self)
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "메모", style: .plain, target: nil, action: nil)
        
        memoTableView.reloadData()
        // 데이터베이스에 아무것도 없으면 테이블뷰 실행 X
        guard memoList.count != 0 else { return }
        
        memoTableView.delegate = self
        memoTableView.dataSource = self
        self.navigationItem.title = "\(memoList.count)개의 메모"
        
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "0개의 메모"
        
    }
    
}

// MARK: - Extension(TableView)

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return memoList.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let row = memoList[indexPath.row]
        
        cell.backgroundColor = .darkGray
        
        cell.cellconfiguration(row: row)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        
        let memo = memoList[indexPath.row]
        
        vc.memoData = memo
//         안됨,,(해결해야 할 부분들 5번 참조)
//         vc.whenYouPressCellAtMainVC()
    
        //셀을 클릭해서 넘어갈 경우 백바버튼아이템 타이틀 변경.
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "검색", style: .plain, target: nil, action: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
4. 메모작성이나 수정하고 돌아오면 서치바가 안보인다 테이블뷰를 스크롤해야 다시나옴.
5. 메모뷰컨트롤러에 텍스트뷰가 분명 존재하는데도 불구하고 메인뷰컨트롤에서 String값을 메모뷰컨트롤러로 넘기는데에 실패함. 자꾸 해당 텍스트뷰가 nil이라고 뜸. 텍스트뷰의 텍스트값이 없어서 그런건가 했지만 그건 또 아님. 텍스트뷰가 없다고 인식하는 듯.
6. 텍스트뷰에서 아무내용도 수정하지 않은 상태에서 백버튼을 클릭하면 alert을 띄워주려고 했다. 그런데 작동안하길래 구글링 해보니 백버튼에는 액션을 넣어줄 수 없다고 한다. 그러면 백버튼 액션으로 수정된 텍스트뷰를 저장하는 것이 불가능하지 않나?
    
    테스트로 메모뷰컨트롤러에 텍스트뷰를 코드로 하나 만들었는데 요건 또 정상적으로 인식함.
 
    -> 일단 대안으로 조건문 처리(메모뷰컨 라인 60)
 
 //자꾸 0번째 섹션의 헤더가 잘리게 나와서 만들어준 헤더 뷰. 없으면 헤더가 잘려서 안보인다. 스크롤해야 보임. -> heightForHeaderInSection메서드로 해결.

*/
