import UIKit

class ThirdViewController: UIViewController {

    enum Section : CaseIterable {
        case bestMovieSection, best, allMoviesSection, allMovies
    }
    struct Item : Hashable {
        let identifier = UUID()
        let movieName: String
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let allMoviesItems:  [Item] = {
        var items = [Item]()
        for i in 0...13 {
            items.append(Item(movieName: "movie\(i)"))
        }
        return items
    }()
    private let bestMovies:  [Item] = {
        var items = [Item]()
        for i in 0...4 {
            items.append(Item(movieName: "movie\(Int.random(in: 0...13))"))
        }
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch indexPath.section {
            case 0, 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as? TitleCell
                cell?.label.text = item.movieName
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCell
                cell?.imageView.image = UIImage(named: item.movieName)
                return cell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.bestMovieSection, .best, .allMoviesSection, .allMovies])
        snapshot.appendItems([Item(movieName: "Best movies")], toSection: .bestMovieSection)
        snapshot.appendItems(bestMovies, toSection: .best)
        snapshot.appendItems([Item(movieName: "All movies")], toSection: .allMoviesSection)
        snapshot.appendItems(allMoviesItems, toSection: .allMovies)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        collectionView.collectionViewLayout = createLayout()
    }

}

//1. UICollectionViewLayout
extension ThirdViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in

          let sectionLayoutKind = Section.allCases[sectionIndex]
          switch (sectionLayoutKind) {
          case .bestMovieSection: return self.generateSecondSectionLayout()
          case .best: return self.generateFirstSectionLayout()
          case .allMoviesSection: return self.generateSecondSectionLayout()
          case .allMovies: return self.generateThirdSectionLayout()
          }
        }
        return layout
    }
    
    func generateFirstSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func generateSecondSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
    
        return section
    }
    
    func generateThirdSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
        top: 5,
        leading: 5,
        bottom: 5,
        trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(0.6)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}
