
import UIKit

final class CarouselViewController: UIViewController {

    var generations: [API.GenerationHead] = [] {
        didSet {
            self.carouselView.pageControl.numberOfPages = self.generations.count
            self.carouselView.collectionView.reloadData()
        }
    }
}

extension CarouselViewController {

    var carouselView: CarouselView {
        return self.view as! CarouselView
    }
}

extension CarouselViewController {

    override func loadView() {
        self.view = CarouselView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.carouselView.collectionView.register(GenerationCarouselCell.self, forCellWithReuseIdentifier: String(describing: GenerationCarouselCell.self))
        self.carouselView.collectionView.dataSource = self
        self.carouselView.collectionView.delegate = self
    }
}


extension CarouselViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.generations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenerationCarouselCell.self), for: indexPath) as! GenerationCarouselCell
        cell.dataSource = .init(generation: self.generations[indexPath.item])
        return cell
    }
}

extension CarouselViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.carouselView.pageControl.currentPage = Int(CGFloat(self.carouselView.pageControl.numberOfPages) * ((scrollView.contentOffset.x + (scrollView.frame.size.width / 2.0)) / scrollView.contentSize.width))
    }
}

extension CarouselViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generation = self.generations[indexPath.item]
        let viewController = ModelViewController(generation: generation)
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 30.0)
    }
}
