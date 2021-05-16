import UIKit
import SafariServices

class NewsViewController: UIViewController {
   
        weak var delegate: NewsViewController?
        let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        return table
    }()
    
    private let newsTableView: NewsTableView = NewsTableView()
    private let searchVC = UISearchController(searchResultsController: nil)
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        view.backgroundColor = .systemBackground
        
        tableView.delegate = newsTableView
        tableView.dataSource = newsTableView
        view.addSubview(tableView)
        newsTableView.delegate = self
        newsTableView.fetchTopStories()
        createSearchBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = newsTableView
    }
}

    //MARK: Extentions

extension NewsViewController: NewsTableViewOutput {
    func reload() {
        tableView.reloadData()
    }
    func searchDismiss() {
        searchVC.dismiss(animated: true, completion: nil)
    }
    
    func onSelected(PresentUrl: URL) {
        let vc = SFSafariViewController(url:PresentUrl)
        self.present(vc, animated: true)
    }
    func getHight() -> CGFloat {
        return view.bounds.height
    }
}


