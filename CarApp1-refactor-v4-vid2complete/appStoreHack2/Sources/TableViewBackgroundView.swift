import UIKit

final class TableViewBackgroundView: UIView {
    
    // all possible states our table can be in, which are neccessary when we load data from external source
    enum State {
        case initial  // 1 where nothing has happened
        case loading  // 2 waiting for response
        case loaded  // 3 we have data
        case empty(String?)  // 4 we have no data
        case error(Error)  // 5 if an error occurs
    }
    
    // Dealing with all different states, what should be visible and when.
    // when we set the state on it, it will configure itself according to the state we give it
    var state: State = .initial {
        didSet {
            switch self.state {
            case .initial:
                self.activityIndicatorView.stopAnimating()
                self.textLabel.text = nil
            case .loading:
                self.activityIndicatorView.startAnimating()
                self.textLabel.text = nil
            case .loaded:
                self.activityIndicatorView.stopAnimating()
                self.textLabel.text = nil
            case .empty(let message):
                self.activityIndicatorView.stopAnimating()
                self.textLabel.textColor = .black
                self.textLabel.text = message

            case .error(let error):
                self.activityIndicatorView.stopAnimating()
                self.textLabel.textColor = .red
                self.textLabel.text = "Error: \(error)"

            }
        }
    }
    
    private let activityIndicatorView: UIActivityIndicatorView
    private let textLabel: UILabel
    
    override init(frame: CGRect) {
        
        self.activityIndicatorView = UIActivityIndicatorView(frame: .zero)
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView.color = .darkGray
        
        self.textLabel = UILabel(frame: .zero)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = .center
        self.textLabel.font = .preferredFont(forTextStyle: .headline)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 242.0 / 255.0, green: 241.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)

        self.addSubview(self.activityIndicatorView)
        self.addSubview(self.textLabel)
        
        NSLayoutConstraint.activate([
            
            self.activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0),
            self.textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
    }
    
    required init?(coder _: NSCoder) {
        fatalError()
    }
}
