
import UIKit

final class GenerationsViewController: UITableViewController {

    private let carouselViewController = CarouselViewController()

    private var generations: [Generation] = [] {
        didSet {
            self.carouselViewController.generations = self.generations
            self.tableView?.reloadData()
        }
    }

    init() {
        super.init(style: .grouped)
        self.title = "Home"
        self.addChild(self.carouselViewController)
        self.carouselViewController.didMove(toParent: self)
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension GenerationsViewController { // UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(GenerationCell.self, forCellReuseIdentifier: "GenerationCell")
        self.tableView.register(CarouselViewCell.self, forHeaderFooterViewReuseIdentifier: "CarouselViewCell")

        let stateView = StateView(frame: .zero)
        self.tableView.backgroundView = stateView

        stateView.state = .loading
        API.shared.generations { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    stateView.state = response.generations.isEmpty ? .empty("Empty") : .loaded
                    self?.generations = response.generations
                case.failure(let error):
                    stateView.state = .error(error)
                }
            }
        }
    }
}

extension GenerationsViewController {  // UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.generations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenerationCell", for: indexPath) as! GenerationCell
        cell.dataSource = .init(generation: self.generations[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CarouselViewCell") as! CarouselViewCell
        view.carouselView = self.carouselViewController.carouselView
        return view
    }
}

extension GenerationsViewController { // UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generation = self.generations[indexPath.item]
        let viewController = ModelViewController(generation: generation)
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}
