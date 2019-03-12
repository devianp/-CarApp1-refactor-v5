
import UIKit

final class CarouselView: UIView {

    let collectionView: UICollectionView
    let pageControl: UIPageControl

    override init(frame: CGRect) {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = .clear
        self.collectionView.isPagingEnabled = true

        self.pageControl = UIPageControl(frame: .zero)
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 247.0 / 255.0, green: 154.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
        self.pageControl.pageIndicatorTintColor = .gray

        super.init(frame: frame)

        self.backgroundColor = .clear

        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)

        NSLayoutConstraint.activate([

            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }
}
