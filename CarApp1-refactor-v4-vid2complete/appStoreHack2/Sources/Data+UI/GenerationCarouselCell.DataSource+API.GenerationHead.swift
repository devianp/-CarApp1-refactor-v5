
import UIKit

extension GenerationCarouselCell.DataSource {
    init(generation: API.GenerationHead) {
        self.image = UIImage(named: "2")
        self.text = generation.name
    }
}
