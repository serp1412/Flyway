import UIKit
import SnapKit

class FlightsViewController: UIViewController {
    private lazy var viewModel = {
        return FlightsViewModel(view: self)
    }()
    
    private enum Section: CaseIterable {
        case main
    }
    
    var collectionView: UICollectionView!
    
    // list collection example taken from https://useyourloaf.com/blog/creating-lists-with-collection-view/
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Airport> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Airport> { cell, _, country in
            var content = cell.defaultContentConfiguration()
            content.text = country.name
            
            content.secondaryText = self.viewModel.distanceToAms(from: country).display
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
            
            cell.contentConfiguration = content
            cell.tintColor = .systemPurple
        }
        
        return UICollectionViewDiffableDataSource<Section, Airport>(collectionView: collectionView) { (collectionView, indexPath, country) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: country)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewLayout())
        createLayout()
        applySnapshot(airports: [], animatingDifferences: false)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewModel.viewDidLoad()
    }
    
    private func applySnapshot(airports: [Airport], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Airport>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(airports)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func createLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension FlightsViewController: AirportDisplayView {
    func show(airports: [Airport]) {
        applySnapshot(airports: airports)
    }
}
