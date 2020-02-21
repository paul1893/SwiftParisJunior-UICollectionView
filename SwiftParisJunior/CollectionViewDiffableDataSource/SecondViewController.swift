import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            
            if indexPath.section == 0 {
                cell.contentView.backgroundColor = .systemBlue
            } else {
                cell.contentView.backgroundColor = .systemRed
            }
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([0, 1, 2, 3], toSection: 0)
        snapshot.appendItems([4, 5, 6], toSection: 1)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
