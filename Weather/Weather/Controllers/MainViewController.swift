//
//  ViewController.swift
//  Weather
//
//  Created by 황민채 on 7/14/24.
//

import UIKit

// 섹션
fileprivate enum MainSection: Hashable {
    case banner
    case hourlyWeather
    case weeklyWeather
    case precipitationMap
    case etcInfo
}

// 아이템, 레이아웃?
fileprivate enum MainItem: Hashable {
    case banner(BannerItem)
    case vertical
    case horizontal
    case map
    case quarter
}

final class MainViewController: BaseViewController {
    
    // 컬렉션뷰
    lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // 데이터 소스
    private var dataSource: UICollectionViewDiffableDataSource<MainSection, MainItem>?
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        bindData()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
       
    }
    
    func bindData() {
        viewModel.inputViewDidLoadTrigger.value = () // 뷰가 로드될 때 트리거 발생
        viewModel.outputData.bind { [weak self] weatherData in
            guard let self = self, let weatherData = weatherData else { return }
            // 네트워크 요청 결과를 받아서 UI 업데이트
            self.updateUI(weatherData)
        }
    }
    
    private func updateUI(_ weatherData: OpenWeather) {
        // 데이터를 사용하여 UI 업데이트
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, MainItem>()
        snapshot.appendSections([.banner])
        
        let bannerItem = MainItem.banner(BannerItem(location: weatherData.sys.country, temperature: Int(weatherData.main.temp), description: weatherData.weather[0].main, maxTemp: Int(weatherData.main.temp), minTemp: Int(weatherData.main.temp)))
        
        snapshot.appendItems([bannerItem], toSection: .banner)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .hourlyWeather:
                return self?.createBannerSection()
            case .weeklyWeather:
                return self?.createBannerSection()
            case .precipitationMap:
                return self?.createBannerSection()
            case .etcInfo:
                return self?.createBannerSection()
            default:
                return self?.createBannerSection()
            }
        }, configuration: config)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainSection, MainItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .banner(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configDetail(location: item.location,
                                  temperature: item.temperature,
                                  description: item.description,
                                  maxTemp: item.maxTemp,
                                  minTemp: item.minTemp)
                
                return cell
            case .vertical, .horizontal, .map, .quarter:
                return UICollectionViewCell()
            }
        })
    }
}

