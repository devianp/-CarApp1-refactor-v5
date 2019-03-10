
import UIKit

final class ModelViewController: UITableViewController {

    struct Section {
        let title: String
        var rows: [Row]
        
    }
    
    struct Row {
        let version: Version
        let text: String
    }
    
    private let generation: Generation
//    private let versions: [Version]
    
    private var sections: [Section] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    init(generation: Generation) {
        self.generation = generation
        super.init(style: .grouped)
        self.title = self.generation.name
    }

    required init?(coder decoder: NSCoder) {
        fatalError()
    }
}

extension ModelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
       
        let headerView = ModelHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.generation = self.generation
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
        
        backgroundView.state = .loading
        headerView.isHidden = true
        // above code hides header until data is loaded
        
        //        self.generations = Generation.generations\
        
        // turn array of versions into array of arrays
        // because it's an array of versions, but grouped by model. 
        
        DataStore.shared.versions(generation: self.generation) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let versions):
                    backgroundView.state = versions.isEmpty ? .empty(nil) : .loaded
                    headerView.isHidden = false
                    
                    var sections = [Section]()
                    for version in versions {
                        let row = Row(version: version, text: version.name)
                        if let index = sections.firstIndex(where: { $0.title == version.model.name }) {
                            sections[index].rows.append(row)
                        }
                        else {
                            let section = Section(title: version.model.name, rows: [row])
                            sections.append(section)
                        }
                    }
                    self?.sections = sections
                case.failure(let error):
                    backgroundView.state = .error(error)
                }
            }
        }
    }
}

extension ModelViewController {  // UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // first of all dequeue with some sort of cell ID
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCell", for: indexPath) as! DefaultTableViewCell
        cell.textLabel!.text = self.sections[indexPath.section].rows[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
}


extension ModelViewController { // UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let version = self.sections[indexPath.section].rows[indexPath.row].version
        let viewController = SpecificationViewController(version: version)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
