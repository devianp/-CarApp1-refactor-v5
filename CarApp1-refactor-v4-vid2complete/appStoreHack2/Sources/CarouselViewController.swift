import UIKit

final class CarouselViewController: UIViewController {
    
    var generations: [Generation] = [] {
        didSet {
            self.carouselView.collectionView.reloadData()
            self.carouselView.pageControl.numberOfPages = self.generations.count
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
        self.carouselView.collectionView.register(GenerationImageCell.self, forCellWithReuseIdentifier: String(describing: GenerationImageCell.self))
        self.carouselView.collectionView.dataSource = self
        self.carouselView.collectionView.delegate = self
    }
}


extension CarouselViewController: UICollectionViewDataSource { // now only for carousel
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.generations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenerationImageCell.self), for: indexPath) as! GenerationImageCell
        cell.generation = self.generations[indexPath.item]
        return cell
    }
}

extension CarouselViewController: UIScrollViewDelegate { // UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.carouselView.pageControl.currentPage = Int(CGFloat(self.carouselView.pageControl.numberOfPages) * ((scrollView.contentOffset.x + (scrollView.frame.size.width / 2.0)) / scrollView.contentSize.width))
    }
}

extension CarouselViewController: UICollectionViewDelegate { // UIScrollViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generation = self.generations[indexPath.item]
        let viewController = ModelViewController(generation: generation)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 30.0)
    }
}
