//
//  WeatherMiniAppView.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 20.01.2023.
//

import UIKit
import CoreLocation

final class WeatherMiniAppView: BaseMiniAppView {
    private let weatherService: WeatherProviding

    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let iconImageView = UIImageView()

    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconHeightConstraint: NSLayoutConstraint!

    init(weatherService: WeatherProviding, frame: CGRect = .zero) {
        self.weatherService = weatherService
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
private extension WeatherMiniAppView {
    func configure(with weather: WeatherModel) {
        cityLabel.text = weather.name
        temperatureLabel.text = "\(Int(weather.main.temp))°C"
        weatherDescriptionLabel.text = weather.weather.first?.description.capitalized ?? ""
    }

    func configureIconImageView() {
        iconImageView.image = UIImage(systemName: "cloud.sun.fill")
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

        temperatureLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .left

        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        weatherDescriptionLabel.textColor = .white
        weatherDescriptionLabel.textAlignment = .left
        weatherDescriptionLabel.numberOfLines = 2
    }
}

// MARK: - Setup Methods
private extension WeatherMiniAppView {
    func setupStackView() {
        let textStackView = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, weatherDescriptionLabel])
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
        temperatureLabel.font = UIFont.systemFont(ofSize: height / 9, weight: .medium)
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: height / 13)
    }
}

// MARK: - Weather Fetch Method
extension WeatherMiniAppView {
    func updateWeather(for location: CLLocation) {
        weatherService.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self?.configure(with: weather)
                }
            case .failure(let error):
                AppLog.networkError("Weather fetch failed", error: error)
                DispatchQueue.main.async {
                    self?.cityLabel.text = "Ошибка"
                    self?.temperatureLabel.text = "Не удалось получить данные"
                    self?.weatherDescriptionLabel.text = ""
                }
            }
        }
    }
}
