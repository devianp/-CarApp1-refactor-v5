
import UIKit

final class DefaultSpecificationViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
//        self.accessoryType = .disclosureIndicator  //arrow
        self.separatorInset = .zero  // line separating rows full width
        self.textLabel!.numberOfLines = 0
        self.detailTextLabel!.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

