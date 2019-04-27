
import UIKit

extension GenerationCarouselCell.DataSource {
    init(generation: API.GenerationHead) {
        self.urlImage = URLImage(url: generation.imageURL)
        self.text = generation.name
    }
}
