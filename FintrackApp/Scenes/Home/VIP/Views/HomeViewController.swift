import UIKit
import CoreData

protocol HomeDisplayLogic: AnyObject {
    func didUpdateDataSource(viewModel: [TransactionCell.ViewModel])
}

final class HomeViewController: UIViewController, UITableViewDelegate {
    var interactor: HomeBusinessLogic?
    var router: HomeRountingLogic?
    
    private var transactionsDataSource: [TransactionCell.ViewModel] = []
    
    private lazy var customView: HomeScreen = {
        guard let view = view as? HomeScreen else {
            fatalError("View is not of type HomeScreen")
        }
        return view
    }()
    
    override func loadView() {
        super.loadView()
        view = HomeScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        view.backgroundColor = Colors.lightBackground
        customView.setupTableViewProtocols(delegate: self, dataSource: self, headerDelegate: self)
        interactor?.fetchTransactionsWith(offset: 0, limit: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.reloadTableView()
    }
}

extension HomeViewController: HomeDisplayLogic {
    func didUpdateDataSource(viewModel: [TransactionCell.ViewModel]) {
        self.transactionsDataSource = viewModel
        customView.reloadTableView()
    }
}

extension HomeViewController: BalanceHeaderViewDelegate {
    func didTapAddTransaction(_ view: BalanceHeaderView, type: TransactionType) {
        router?.routeToAddTransaction(with: type)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderSectionView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as? TransactionCell {
            cell.configure(with: transactionsDataSource[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}
