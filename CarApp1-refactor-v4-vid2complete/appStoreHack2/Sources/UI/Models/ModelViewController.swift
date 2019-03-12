
import UIKit

final class ModelViewController: UITableViewController {

    struct Section {
        let title: String
        var rows: [Row]
    }

    struct Row {
        let version: Version
        let dataSource: ModelCell.DataSource
    }

    private let generation: Generation

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

    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension ModelViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(ModelCell.self, forCellReuseIdentifier: "ModelCell")

        let headerView = ModelHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.image = UIImage(named: "2") // self.generation.imageURL

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
        API.shared.generation(id: self.generation.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    backgroundView.state = response.versions.isEmpty ? .empty(nil) : .loaded
                    headerView.text = response.summary
                    headerView.layoutIfNeeded()
                    self?.tableView.tableHeaderView = headerView
                    self?.sections = .init(versions: response.versions)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModelCell", for: indexPath) as! ModelCell
        cell.dataSource = self.sections[indexPath.section].rows[indexPath.row].dataSource
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
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}
