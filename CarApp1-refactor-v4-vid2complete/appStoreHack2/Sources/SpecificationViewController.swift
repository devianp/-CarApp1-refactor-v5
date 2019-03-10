import UIKit

final class SpecificationViewController: UITableViewController {
    
    struct Section {
        let title: String
        var rows: [Row]
    }
    
    struct Row {
        let key: String
        let value: String
    }
    
    private let version: Version
    
    private var sections: [Section] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(version: Version) {
        self.version = version
        super.init(style: .grouped)
        self.title = self.version.name
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError()
    }
}


extension SpecificationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DefaultSpecificationViewCell.self, forCellReuseIdentifier: "DefaultSpecificationViewCell")
        
        let headerView = SpecificationHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.version = self.version
        self.tableView.tableHeaderView = headerView
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            headerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor),
            headerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor)
            ])
        
        headerView.layoutIfNeeded()
        self.tableView.tableHeaderView = headerView
        
        let backgroundView = TableViewBackgroundView(frame: .zero)
        self.tableView.backgroundView = backgroundView
        
// code above works
        
        // hide header until data is loaded
        backgroundView.state = .loading
        headerView.isHidden = true
        
        DataStore.shared.metrics(version: self.version){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let metrics):
                    // if generatiosn is empty, set to empty state otherwise set to loaded state
                    backgroundView.state = metrics.isEmpty ? .empty("Empty") : .loaded
                    headerView.isHidden = false
                    // ....
                    var sections = [Section]()
                    for metric in metrics {
                        let row = Row(key: metric.key, value: metric.value)
                        if let index = sections.firstIndex(where: { $0.title == metric.category }) {
                            sections[index].rows.append(row)
                    }
                    else {
                        let section = Section(title: metric.category, rows: [row])
                        sections.append(section)
                        }
                    }
                    self?.sections = sections
                case.failure(let error):
                    // if failed set to error
                    backgroundView.state = .error(error)

                }
            }
        }
    }
}



extension SpecificationViewController {  // UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // first of all dequeue with some sort of cell ID
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSpecificationViewCell", for: indexPath) as! DefaultSpecificationViewCell
        cell.textLabel!.text = self.sections[indexPath.section].rows[indexPath.row].key
        cell.detailTextLabel!.text = self.sections[indexPath.section].rows[indexPath.row].value
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
}
