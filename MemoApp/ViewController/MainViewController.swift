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
    
    var showViewControllerOnce: Bool = false
    let localRealm = try! Realm()
    var memoList: Results<MemoList>!
    var searchFilterList: Results<MemoList>!
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let searchbarText = searchController?.searchBar.text?.isEmpty == false
        return isActive && searchbarText
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstVC()
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

    func firstVC() {
        
        let nowStatus = UserDefaults.standard.bool(forKey: "showOnce")
        if nowStatus == false {
            
            let sb = UIStoryboard(name: "FirstScreen", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            
            present(vc, animated: true, completion: nil)
            
            showViewControllerOnce = true
            UserDefaults.standard.set(showViewControllerOnce, forKey: "showOnce")
        }
    }

    func topViewSetting() {
        
        view.backgroundColor = .darkGray
        
        let searchController = UISearchController(searchResultsController: nil)
        let insideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        
        insideSearchBar?.textColor = .white
        insideSearchBar?.backgroundColor = .systemGray
        searchController.searchBar.placeholder = "검색"
        searchController.searchResultsUpdater = self
        
        self.navigationItem.title = "0개의 메모"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Extension(TableView)

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isFiltering {
            return section == 0 ? searchFilterList.count : 0
        } else {
            if section == 0 {
                let fixedList = memoList.filter("favoriteStatus == true")
                return fixedList.count
            } else {
                let noFixedList = memoList.filter("favoriteStatus == false")
                return noFixedList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let fixedList = memoList.filter("favoriteStatus == true")
        let noFixedList = memoList.filter("favoriteStatus == false")
        
        cell.backgroundColor = .darkGray

        if self.isFiltering {
            if indexPath.section == 0 {
                let filterRow = searchFilterList.reversed()[indexPath.row]
                
                cell.cellconfiguration(row: filterRow)
            }
        } else {
            if indexPath.section == 0 {
                if fixedList.count != 0 {
                    let fixedRow = fixedList.reversed()[indexPath.row]
                    cell.cellconfiguration(row: fixedRow)
                }
            } else {
                if noFixedList.count != 0 {
                    let row = noFixedList.reversed()[indexPath.row]
                    cell.cellconfiguration(row: row)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Content", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MemoViewController") as! MemoViewController
        
        if self.isFiltering {
            if indexPath.section == 0 {
                let memo = searchFilterList.reversed()[indexPath.row]
                vc.memoData = memo
            }
        } else {
            if indexPath.section == 0 {
                let memo = memoList.filter("favoriteStatus == true").reversed()[indexPath.row]
                vc.memoData = memo
            } else {
                let memo = memoList.filter("favoriteStatus == false").reversed()[indexPath.row]
                vc.memoData = memo
            }
        }
        //셀을 클릭해서 넘어갈 경우 백바버튼아이템 타이틀 변경.
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "검색", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        //회색표시 없애기
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fixedList = memoList.filter("favoriteStatus == true")
        let noFixedList = memoList.filter("favoriteStatus == false")
        
        let favoriteAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            
            if fixedList.count < 5 {
                try! self.localRealm.write {
                    if indexPath.section == 0 {
                        if fixedList.count != 0 {
                            let fixedRow = fixedList.reversed()[indexPath.row]
                            fixedRow.favoriteStatus.toggle()
                        }
                    } else {
                        if noFixedList.count != 0 {
                            let row = noFixedList.reversed()[indexPath.row]
                            row.favoriteStatus.toggle()
                        }
                    }
                    tableView.reloadData()
                }
            } else {
                showToast(vc: self, message: "메모는 5개이상 불가능!", font: UIFont.systemFont(ofSize: 15))
            }
            completionHandler(true)
        }
        
        favoriteAction.backgroundColor = .systemOrange
        
        if indexPath.section == 0 {
            if fixedList.count != 0 {
                let fixedRow = fixedList.reversed()[indexPath.row]
                if fixedRow.favoriteStatus == true {
                    favoriteAction.image = UIImage(systemName: "pin.slash.fill")
                } else {
                    favoriteAction.image = UIImage(systemName: "pin.fill")
                }
            }
        } else {
            if noFixedList.count != 0 {
                let row = noFixedList.reversed()[indexPath.row]
                if row.favoriteStatus == true {
                    favoriteAction.image = UIImage(systemName: "pin.slash.fill")
                } else {
                    favoriteAction.image = UIImage(systemName: "pin.fill")
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fixedList = memoList.filter("favoriteStatus == true")
        let noFixedList = memoList.filter("favoriteStatus == false")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            
            let alert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                
                try! self.localRealm.write {
                    if indexPath.section == 0 {
                        if fixedList.count != 0 {
                            let fixedRow = fixedList.reversed()[indexPath.row]
                            self.localRealm.delete(fixedRow)
                        }
                    } else {
                        if noFixedList.count != 0 {
                            let row = noFixedList.reversed()[indexPath.row]
                            self.localRealm.delete(row)
                        
                        }
                    }
                    tableView.reloadData()
                    self.navigationItem.title = "\(self.memoList.count)개의 메모"

                }
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      
        //고정된 메모가 없을 때 높이 0으로 설정.
        let fixedList = memoList.filter("favoriteStatus == true")
        if section == 0 {
           if fixedList.count != 0 {
                return 50
           } else {
                return 0
            }
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        let sectionLabel = UILabel()
        let fixedList = memoList.filter("favoriteStatus == true")
        let noFixedList = memoList.filter("favoriteStatus == false")

        sectionLabel.font = UIFont.boldSystemFont(ofSize: 25)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false

        if self.isFiltering {
            if section == 0 {
                sectionLabel.text = "\(searchFilterList.count)개 찾음"
                let _ = headerView.safeAreaLayoutGuide
                headerView.bounds = headerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
                headerView.addSubview(sectionLabel)
            }
            return headerView
            
        } else if section == 0 {
            if fixedList.count != 0 {
                sectionLabel.text = "고정된 메모"
                let _ = headerView.safeAreaLayoutGuide // 이유는 알 수 없지만 해당 상수를 넣지 않으면 처음에는 헤더가 존재하나 스크롤 했다가 돌아오면 헤더가 사라져버린다;
                headerView.bounds = headerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
                headerView.addSubview(sectionLabel)

                if fixedList.count == 0 {
                    headerView.isHidden = true
                }
            }
            return headerView
            
        } else {
            sectionLabel.text = "메모"
            let _ = headerView.safeAreaLayoutGuide // 위에 거랑 얘 둘다 없애면 헤더 두 개다 사라짐. 쓰지도 않는데 왜사라지지
                        
            headerView.bounds = headerView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
            headerView.addSubview(sectionLabel)
            
            if noFixedList.count == 0 {
                headerView.isHidden = true
            }
            
            return headerView
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        //서치뷰 필터처리
        self.searchFilterList = self.memoList.where {
            ($0.title.contains(text) || $0.subContent.contains(text))
        }
        self.memoTableView.reloadData()
    
    }
}

/* 해결해야 할 부분 및 정리

총 소요시간: 31시간(제출일 6시 기준 아직 미완성,,)
1. 섹션 헤더의 좌측 마진값을 없애고 싶은데 아직 해결못함. -> 해결 viewForHeaderInSection 메서드 이용. 헤더뷰를 따로 만들어줌.
    헤더뷰 위에 마진값 줘야함.
2. 셀과 셀사이 보더 왼쪽 마진 때문에 보더라인이 끊겨 있다.
3. 0번째 섹션의 헤더가 네비게이션바와 너무 붙어있음. -> 헤더의 높이를 가능한 높인 다음, 헤더뷰 내부 패딩값을 줘서 해결
4. 메모작성이나 수정하고 돌아오면 서치바가 안보인다 테이블뷰를 스크롤해야 다시나옴. (해결)
    -> self.navigationItem.hidesSearchBarWhenScrolling = false 하니까 다른 뷰 갔다와도 잘 보인다! 근데 이 메서드는 테이블뷰 스크롤할때 계속 서치바가 보여주게끔 하는 메서드인데 내가 겪은 이슈랑 무슨 상관이 있는지는 아직 모르겠음.
5. 메모뷰컨트롤러에 텍스트뷰가 분명 존재하는데도 불구하고 메인뷰컨트롤에서 String값을 메모뷰컨트롤러로 넘기는데에 실패함. 자꾸 해당 텍스트뷰가 nil이라고 뜸. 텍스트뷰의 텍스트값이 없어서 그런건가 했지만 그건 또 아님. 텍스트뷰가 없다고 인식하는 듯.
    
    테스트로 메모뷰컨트롤러에 텍스트뷰를 코드로 하나 만들었는데 요건 또 정상적으로 인식함.
    -> 일단 대안으로 조건문 처리(메모뷰컨트롤러 Line 140)
 
 6. 텍스트뷰에서 아무내용도 수정하지 않은 상태에서 백버튼을 클릭하면 alert을 띄워주려고 했다. 그런데 작동안하길래 구글링 해보니 백버튼에는 액션을 넣어줄 수 없다고 한다. 그러면 백버튼 액션으로 수정된 텍스트뷰를 저장하는 것이 불가능하지 않나?
 7. 리딩 스와이프 관련해서 너무 시간 잡아먹어서(한 5시간 쓴듯) 스트레스 너무 받았지만 정말 단순한 문제였어서 후련한데 허탈.
 8. 서치뷰 필터처리관련해서 NSPredicate로는 제한사항이 존재했고 관련 내용 구글링 중, Realm Swift 10.19 버전이 최근에 나온거 확인 후 관련 메서드를 이용. 서치뷰 필터처리를 손쉽게 할 수 있었다.
 9. 날짜, 넘버 포메터 구현해야함.
 10. 검색화면에서 리딩스와이프, 트레일링 스와이프 미구현. 텍스트컬러 변경 미구현.

 //자꾸 0번째 섹션의 헤더가 잘리게 나와서 만들어준 헤더 뷰. 없으면 헤더가 잘려서 안보인다. 스크롤해야 보임. -> heightForHeaderInSection메서드로 해결.

*/
