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
    case vertical(HourlyItem)
    case horizontal(WeeklyItem)
    case map
    case quarter(EtcInfoItem)
}

final class MainViewController: BaseViewController {
    
    // 컬렉션뷰
    lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.identifier)
        collectionView.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: VerticalCollectionViewCell.identifier)
        collectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
        collectionView.register(QuarterCollectionViewCell.self, forCellWithReuseIdentifier: QuarterCollectionViewCell.identifier)
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
        
        viewModel.outputNetworkRequestCompleted.bind { [weak self] _ in
            guard let self = self else { return }
            
            // 모든 네트워크 요청이 완료된 후 데이터를 업데이트
            var snapshot = NSDiffableDataSourceSnapshot<MainSection, MainItem>()
            snapshot.appendSections([.banner, .hourlyWeather, .weeklyWeather, .precipitationMap, .etcInfo])
            
            if let weatherData = self.viewModel.outputWeatherData.value {
                let bannerItem = MainItem.banner(BannerItem(location: weatherData.sys.country, temperature: Int(weatherData.main.temp), description: weatherData.weather[0].main, maxTemp: Int(weatherData.main.temp), minTemp: Int(weatherData.main.temp)))
                snapshot.appendItems([bannerItem], toSection: .banner)
            }
            
            if let hourlyData = self.viewModel.outputHourlyData.value {
                let hourlyItems = hourlyData.list.map { MainItem.vertical(HourlyItem(hour: $0.dt, icon: $0.weather[0].icon, temp: $0.main.temp)) }
                snapshot.appendItems(hourlyItems, toSection: .hourlyWeather)
            }
            
            if let weeklyData = self.viewModel.outputWeeklyData.value {
                let weeklyItems = weeklyData.list.map { MainItem.horizontal(WeeklyItem(dayOfWeek: $0.dt, icon: $0.weather[0].icon, maxTemp: $0.main.tempMax, minTemp:$0.main.tempMin )) }
                snapshot.appendItems(weeklyItems, toSection: .weeklyWeather)
            }
            
            // 기타 섹션에 대한 항목 추가
            snapshot.appendItems([MainItem.map], toSection: .precipitationMap)
            snapshot.appendItems([MainItem.quarter(EtcInfoItem(title: "기타 정보", content: "추가 정보"))], toSection: .etcInfo)
            
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
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
                return self?.createHourlyWeatherSection()
            case .weeklyWeather:
                return self?.createWeeklyWeatherSection()
            case .precipitationMap:
                return self?.createMapSection()
            case .etcInfo:
                return self?.createEtcInfoSection()
            default:
                return self?.createBannerSection()
            }
        }, configuration: config)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func createHourlyWeatherSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createWeeklyWeatherSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createMapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func createEtcInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
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
            case .vertical(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.identifier, for: indexPath) as? HorizontalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(hour: item.hour, icon: item.icon, temp: item.temp)
                
                return cell
            case .horizontal(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCollectionViewCell.identifier, for: indexPath) as? VerticalCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(dayOfWeek: item.dayOfWeek, icon: item.icon, minTemp: item.minTemp, maxTemp: item.maxTemp)
                
                return cell
            case .map:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath) as? MapCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure()
                
                return cell
            case .quarter(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuarterCollectionViewCell.identifier, for: indexPath) as? QuarterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configure(title: item.title, content: item.content)
                
                return cell
            }
        })
    }
}

