
import UIKit

extension GenerationCell.DataSource {
    init(generation: API.GenerationHead) {
        self.text = generation.name
    }
}
