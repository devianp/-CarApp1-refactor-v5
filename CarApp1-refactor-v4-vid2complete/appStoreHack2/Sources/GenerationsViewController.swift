
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
        
        self.tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "DefaultTableViewCell")
        self.tableView.register(CarouselViewCell.self, forHeaderFooterViewReuseIdentifier: "CarouselViewCell")
        
        let backgroundView = TableViewBackgroundView(frame: .zero)
        self.tableView.backgroundView = backgroundView
        
//        //json test
//        let generationURLString = "https://e6dl4159e4.execute-api.eu-west-2.amazonaws.com/dev/generations"
//        
////        guard let url = URL(string: generationURLString) else {
////            return
////        }
//        
//        URLSession.shared.dataTask(with: URL(string: generationURLString)!, completionHandler: { (data, response, error) -> Void in
//            
//            guard let data = data else { return }
//            
//            if let error = error {
//                print(error)
//                return
//            }
//            
//            do {
//                
//                let decoder = JSONDecoder()
//                let appDetail = try decoder.decode(App.self, from: data)
//                
//                self.app = appDetail
//                
//                DispatchQueue.main.async(execute: { () -> Void in
//                    self.collectionView?.reloadData()
//                })
//                
//            } catch let err {
//                print(err)
//            }
//            
//            
//        }).resume()
//        //json test

        
        // in loading state before we make request
        backgroundView.state = .loading
//        self.generations = Generation.generations
        DataStore.shared.generations { [weak self] result in
            // main queue exists in foreground anything with UI is executed in main queue
            DispatchQueue.main.async {
                switch result {
                case .success(let generations):
                    // if generatiosn is sempty, set to empty state otherwise set to loaded state
                    backgroundView.state = generations.isEmpty ? .empty("Empty") : .loaded
                    self?.generations = generations
                case.failure(let error):
                    // if failed set to error
                    backgroundView.state = .error(error)

                }
            }
        }
    }
}

extension GenerationsViewController {  // UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.generations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultTableViewCell", for: indexPath) as! DefaultTableViewCell
        cell.textLabel!.text = self.generations[indexPath.row].name
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
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
