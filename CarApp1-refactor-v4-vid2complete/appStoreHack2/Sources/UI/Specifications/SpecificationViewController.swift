
import UIKit

final class SpecificationViewController: UITableViewController {

    private let version: API.VersionHead
    private var specifications: [API.Specification] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    init(version: API.VersionHead) {
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
        API.shared.version(id: self.version.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let version):
                    backgroundView.state = version.specifications.isEmpty ? .empty(nil) : .loaded
                    headerView.urlImage = URLImage(url: version.imageURL)
                    headerView.text = version.summary
                    headerView.layoutIfNeeded()
                    self?.tableView.tableHeaderView = headerView
                    self?.specifications = version.specifications
                case.failure(let error):
                    backgroundView.state = .error(error)
                }
            }
        }
    }
}

extension SpecificationViewController {  // UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.specifications.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.specifications[section].metrics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationCell", for: indexPath) as! SpecificationCell
        cell.dataSource = .init(metric: self.specifications[indexPath.section].metrics[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.specifications[section].name
    }
}
