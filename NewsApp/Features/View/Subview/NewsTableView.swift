import  UIKit
import SafariServices

//MARK: Protocols

protocol NewsTableViewOutput: AnyObject {
    func onSelected(PresentUrl: URL)
    func getHight() -> CGFloat
    func reload()
    func searchDismiss()
}

protocol NewsTableViewProtocol {
    func update (items: [Article])
}

final class NewsTableView: NSObject {


    weak var delegate: NewsTableViewOutput?
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? Constants.null)  else {
            return
        }
        self.delegate?.onSelected(PresentUrl: url)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //MARK: SearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? Constants.descirption, imageURL: URL(string:$0.urlToImage ?? Constants.null) )})
                
                DispatchQueue.main.async {
                    self?.delegate?.reload()
                    self?.delegate?.searchDismiss()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: FetchData
    
    func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({NewsTableViewCellViewModel(title: $0.title, subtitle: $0.description ?? Constants.descirption, imageURL: URL(string:$0.urlToImage ?? Constants.null) )})
                
                DispatchQueue.main.async {
                    self?.delegate?.reload()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension NewsTableView: UITableViewDelegate, UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
}
