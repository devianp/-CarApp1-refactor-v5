
import UIKit

final class SpecificationViewController: UITableViewController {

    struct Section {
        let title: String
        var rows: [Row]
    }

    struct Row {
        let dataSource: SpecificationCell.DataSource
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

    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension SpecificationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SpecificationCell.self, forCellReuseIdentifier: "SpecificationCell")

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

        let backgroundView = StateView(frame: .zero)
        self.tableView.backgroundView = backgroundView

        backgroundView.state = .loading
        headerView.isHidden = true

//        DataStore.shared.metrics(version: self.version) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let metrics):
//                    backgroundView.state = metrics.isEmpty ? .empty("Empty") : .loaded
//                    headerView.isHidden = false
//                    self?.sections = .init(metrics: metrics)
//                case.failure(let error):
//                    backgroundView.state = .error(error)
//                }
//            }
//        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationCell", for: indexPath) as! SpecificationCell
        cell.dataSource = self.sections[indexPath.section].rows[indexPath.row].dataSource
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
}
