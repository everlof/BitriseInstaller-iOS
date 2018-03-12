import UIKit
import RxSwift
import RxCocoa

class AppDetailViewController: UIViewController {

    let app: App

    let builds = BehaviorSubject<[Build]>(value: [Build]())

    let tableView = UITableView()

    let disposeBag = DisposeBag()

    init(app: App) {
        self.app = app

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .white
        tableView.register(BuildCell.self, forCellReuseIdentifier: BuildCell.reuseIdentifier)

        super.init(nibName: nil, bundle: nil)
        title = app.title
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        builds
            .bind(to: tableView.rx.items(cellIdentifier: BuildCell.reuseIdentifier, cellType: BuildCell.self))
            { row, build, cell in
                cell.configure(for: build)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let vc = BuildDetailViewController(app: self.app, build: try! self.builds.value()[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        API.shared.builds(for: app)
            .subscribe(onNext: { builds in
                self.builds.onNext(builds)
            })
            .disposed(by: disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
