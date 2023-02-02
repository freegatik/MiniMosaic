//
//  LocationMiniAppView.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 20.01.2023.
//

import UIKit
import CoreLocation

final class LocationMiniAppView: BaseMiniAppView {
    private let geocoding: LocationGeocodingProviding

    private let cityLabel = UILabel()
    private let coordinatesLabel = UILabel()
    private let iconImageView = UIImageView()

    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconHeightConstraint: NSLayoutConstraint!

    init(geocoding: LocationGeocodingProviding, frame: CGRect = .zero) {
        self.geocoding = geocoding
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupView() {
        super.setupView()
        configureIconImageView()
        configureLabels()
        setupStackView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustLayoutForSize(bounds.size)
    }
}

// MARK: - Configure Methods
private extension LocationMiniAppView {
    func configureIconImageView() {
        iconImageView.image = UIImage(systemName: "location.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
    }

    func configureLabels() {
        cityLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cityLabel.textColor = .white
        cityLabel.textAlignment = .left
        cityLabel.numberOfLines = 1
        cityLabel.adjustsFontSizeToFitWidth = true

        coordinatesLabel.font = UIFont.systemFont(ofSize: 16)
        coordinatesLabel.textColor = .white
        coordinatesLabel.textAlignment = .left
        coordinatesLabel.numberOfLines = 1
        coordinatesLabel.adjustsFontSizeToFitWidth = true
    }
}

// MARK: - Setup Methods
private extension LocationMiniAppView {
    func setupStackView() {
        let textStackView = UIStackView(arrangedSubviews: [cityLabel, coordinatesLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .leading

        let mainStackView = UIStackView(arrangedSubviews: [iconImageView, textStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .center

        addSubview(mainStackView)
        setupConstraints(for: mainStackView)
    }

    func setupConstraints(for stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 50)
        iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 50)
        iconWidthConstraint.isActive = true
        iconHeightConstraint.isActive = true
    }

    func adjustLayoutForSize(_ size: CGSize) {
        let height = size.height

        let iconSize = height / 4
        iconWidthConstraint.constant = iconSize
        iconHeightConstraint.constant = iconSize

        cityLabel.font = UIFont.boldSystemFont(ofSize: height / 11)
        coordinatesLabel.font = UIFont.systemFont(ofSize: height / 13)
    }
}

// MARK: - Location Fetch Method
extension LocationMiniAppView {
    func updateLocation(with location: CLLocation) {
        geocoding.reverseGeocode(location: location) { [weak self] result in
            switch result {
            case .success(let locationModel):
                DispatchQueue.main.async {
                    self?.cityLabel.text = locationModel.city
                    self?.coordinatesLabel.text = locationModel.coordinates
                }
            case .failure(let error):
                AppLog.networkError("Reverse geocode failed", error: error)
                DispatchQueue.main.async {
                    self?.cityLabel.text = "Ошибка"
                    self?.coordinatesLabel.text = "Не удалось получить данные"
                }
            }
        }
    }
}
