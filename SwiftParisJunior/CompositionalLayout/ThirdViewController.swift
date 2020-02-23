import UIKit

class ThirdViewController: UIViewController {
    
    enum Section : CaseIterable {
        case titleBest, best, titleAll, all
    }
    struct Item : Hashable {
        let identifier = UUID()
        let movieName: String
    }
    
    private let titleIdentifier = "title"
    private let cellIdentifier = "cell"
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
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch Section.allCases[indexPath.section] {
            case .titleAll, .titleBest:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.titleIdentifier, for: indexPath) as? TitleCell
                cell?.label.text = item.movieName
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? MovieCell
                cell?.imageView.image = UIImage(named: item.movieName)
                return cell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.titleBest, .best, .titleAll, .all])
        snapshot.appendItems([Item(movieName: "Best movies")], toSection: .titleBest)
        snapshot.appendItems(bestMovies, toSection: .best)
        snapshot.appendItems([Item(movieName: "All movies")], toSection: .titleAll)
        snapshot.appendItems(allMoviesItems, toSection: .all)
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
            
            let sectionKind = Section.allCases[sectionIndex]
            
            switch sectionKind {
            case .titleAll, .titleBest: return self.generateTitleSection()
            case .best: return self.generateBestSection()
            case .all: return self.generateAllSection()
            }
        }
        return layout
    }
    
    func generateBestSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)
            ), subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func generateTitleSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(64)
        ), subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func generateAllSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/2)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(2/3)
            ), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        return section
    }
}
