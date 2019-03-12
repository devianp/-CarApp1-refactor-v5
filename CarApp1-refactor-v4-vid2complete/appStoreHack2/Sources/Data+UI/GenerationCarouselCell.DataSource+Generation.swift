
import UIKit

extension GenerationCarouselCell.DataSource {
    init(generation: Generation) {
        self.image = UIImage(named: "2")
        self.text = generation.name
    }
}
