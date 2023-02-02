//
//  MiniAppListViewController.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 22.01.2023.
//

import UIKit
import CoreLocation

final class MiniAppListViewController: UIViewController {
    private let viewModel: MiniAppListViewModel

    private let locationManager = CLLocationManager()
    private var collectionView: UICollectionView!

    init(environment: AppEnvironment = .live) {
        let factory = MiniAppFactory(environment: environment)
        self.viewModel = MiniAppListViewModel(factory: factory)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBarButtons()
        setupCollectionView()
        setupLocationManager()
        viewModel.loadMiniApps()
        collectionView.reloadData()
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

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CollectionView Data Source Methods
extension MiniAppListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.miniApps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MiniAppCell",
            for: indexPath
        ) as? MiniAppCollectionViewCell else {
            preconditionFailure("MiniAppCell must be MiniAppCollectionViewCell")
        }
        let miniApp = viewModel.miniApps[indexPath.item]

        cell.configure(with: miniApp)
        cell.isUserInteractionEnabled = viewModel.interactionEnabled
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screenHeight = view.bounds.height
        let screenWidth = view.bounds.width
        let height = screenHeight * viewModel.cellHeightFactor
        return CGSize(width: screenWidth, height: height)
    }
}

// MARK: - Buttons Methods
private extension MiniAppListViewController {
    func setupNavigationBarButtons() {
        let oneEightScreenButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.split.3x3.fill"),
            style: .plain,
            target: self,
            action: #selector(showOneEighthScreen)
        )
        let halfScreenButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.grid.1x2.fill"),
            style: .plain,
            target: self,
            action: #selector(showHalfScreen)
        )
        let fullScreenButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.fill"),
            style: .plain,
            target: self,
            action: #selector(showFullScreen)
        )

        oneEightScreenButton.accessibilityLabel = String(localized: "accessibility.layout.mode.compact")
        halfScreenButton.accessibilityLabel = String(localized: "accessibility.layout.mode.half")
        fullScreenButton.accessibilityLabel = String(localized: "accessibility.layout.mode.full")

        navigationItem.leftBarButtonItems = [oneEightScreenButton, halfScreenButton, fullScreenButton]
    }

    @objc func showOneEighthScreen() {
        viewModel.setLayoutMode(.compactRows)
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionViewLayout()
        }
    }

    @objc func showHalfScreen() {
        viewModel.setLayoutMode(.halfRows)
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionViewLayout()
        }
    }

    @objc func showFullScreen() {
        viewModel.setLayoutMode(.fullRows)
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionViewLayout()
        }
    }

    func updateCollectionViewLayout() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.collectionView.performBatchUpdates({
                self.collectionView.collectionViewLayout.invalidateLayout()
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                self.collectionView.reloadItems(at: visibleIndexPaths)
            }, completion: nil)
        }
    }
}

// MARK: - Location
extension MiniAppListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        for miniApp in viewModel.miniApps {
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
