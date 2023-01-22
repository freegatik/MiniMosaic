//
//  MiniAppListViewController.swift
//  MiniMosaic
//
//  Created by Богдан Тарченко on 03.09.2024.
//

import UIKit
import CoreLocation

class MiniAppListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    private var miniApps: [BaseMiniAppView] = []
    private var collectionView: UICollectionView!
    
    private var cellHeightFactor: CGFloat = 1/8
    private var interactionEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBarButtons()
        setupCollectionView()
        setupLocationManager()
        loadMiniApps()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Setup Methods
private extension MiniAppListViewController {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MiniAppCollectionViewCell.self, forCellWithReuseIdentifier: "MiniAppCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadMiniApps() {
        for _ in 1...14 {
            let miniApp: BaseMiniAppView
            switch Int.random(in: 0...2) {
            case 0:
                miniApp = WeatherMiniAppView()
            case 1:
                miniApp = LocationMiniAppView()
            default:
                miniApp = NewsMiniAppView()
            }
            miniApps.append(miniApp)
        }
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Data Source Methods
extension MiniAppListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MiniAppCell", for: indexPath) as! MiniAppCollectionViewCell
        let miniApp = miniApps[indexPath.item]
        
        cell.configure(with: miniApp)
        cell.contentView.addSubview(miniApp)
        miniApp.frame = cell.contentView.bounds
        cell.isUserInteractionEnabled = interactionEnabled
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = view.bounds.height
        let screenWidth = view.bounds.width
        let height = screenHeight * cellHeightFactor
        return CGSize(width: screenWidth, height: height)
    }
}

// MARK: - Buttons Methods
private extension MiniAppListViewController {
    func setupNavigationBarButtons() {
        let oneEightScreenButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.split.3x3.fill"), style: .plain, target: self, action: #selector(showOneEighthScreen))
        let halfScreenButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.1x2.fill"), style: .plain, target: self, action: #selector(showHalfScreen))
        let fullScreenButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.fill"), style: .plain, target: self, action: #selector(showFullScreen))
        
        navigationItem.leftBarButtonItems = [oneEightScreenButton, halfScreenButton, fullScreenButton]
    }
    
    @objc func showOneEighthScreen() {
        cellHeightFactor = 1/8
        interactionEnabled = false
        DispatchQueue.main.async {
            self.updateCollectionViewLayout()
        }
    }
    
    @objc func showHalfScreen() {
        cellHeightFactor = 1/2
        interactionEnabled = true
        DispatchQueue.main.async {
            self.updateCollectionViewLayout()
        }
    }
    
    @objc func showFullScreen() {
        cellHeightFactor = 1
        interactionEnabled = true
        DispatchQueue.main.async {
            self.updateCollectionViewLayout()
        }
    }
    
    func updateCollectionViewLayout() {
        UIView.animate(withDuration: 0.3) {
            self.collectionView.performBatchUpdates({
                self.collectionView.collectionViewLayout.invalidateLayout()
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                self.collectionView.reloadItems(at: visibleIndexPaths)
            }, completion: nil)
        }
    }
}

// MARK: - Location Methods
extension MiniAppListViewController {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            for miniApp in miniApps {
                if let weatherView = miniApp as? WeatherMiniAppView {
                    weatherView.updateWeather(for: location)
                } else if let locationView = miniApp as? LocationMiniAppView {
                    locationView.updateLocation(with: location)
                }
            }
            collectionView.reloadData()
            locationManager.stopUpdatingLocation()
        }
    }
}

