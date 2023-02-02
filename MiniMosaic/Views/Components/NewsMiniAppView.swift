//
//  NewsMiniAppView.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 20.01.2023.
//

import UIKit

final class NewsMiniAppView: BaseMiniAppView {
    private let newsService: NewsProviding

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView()

    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconHeightConstraint: NSLayoutConstraint!

    private var newsItem: NewsItem? {
        didSet {
            updateView()
        }
    }

    init(newsService: NewsProviding, frame: CGRect = .zero) {
        self.newsService = newsService
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
        fetchNews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustLayoutForSize(bounds.size)
    }
}

// MARK: - Configure Methods
private extension NewsMiniAppView {
    func configureIconImageView() {
        iconImageView.image = UIImage(systemName: "newspaper")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
    }

    func configureLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
    }
}

// MARK: - Setup Methods
private extension NewsMiniAppView {
    func setupStackView() {
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
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

        titleLabel.font = UIFont.boldSystemFont(ofSize: height / 13)
        descriptionLabel.font = UIFont.systemFont(ofSize: height / 13)
    }

    func updateView() {
        guard let newsItem else { return }
        titleLabel.text = newsItem.title
        descriptionLabel.text = newsItem.description
    }
}

// MARK: - News Fetch Method
private extension NewsMiniAppView {
    func fetchNews() {
        newsService.fetchTopHeadlines { [weak self] result in
            switch result {
            case .success(let newsResponse):
                if let firstArticle = newsResponse.articles.first {
                    DispatchQueue.main.async {
                        self?.newsItem = firstArticle
                    }
                }
            case .failure(let error):
                AppLog.networkError("News fetch failed", error: error)
                DispatchQueue.main.async {
                    self?.titleLabel.text = "Ошибка"
                    self?.descriptionLabel.text = "Не удалось получить данные"
                }
            }
        }
    }
}
