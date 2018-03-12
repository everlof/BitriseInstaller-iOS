import UIKit
import RxSwift
import RxCocoa

class ListAppsViewController: UIViewController {

    let apps = BehaviorSubject<[App]>(value: [App]())

    let tableView = UITableView()

    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Apps"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .white
        tableView.register(AppCell.self, forCellReuseIdentifier: AppCell.reuseIdentifier)

        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        apps
            .bind(to: tableView.rx.items(cellIdentifier: AppCell.reuseIdentifier, cellType: AppCell.self))
            { row, app, cell in
                cell.configure(for: app)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let vc = AppDetailViewController(app: try! self.apps.value()[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        API.shared.apps()
            .subscribe(onNext: { apps in
                self.apps.onNext(apps)
            })
            .disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
