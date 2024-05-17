//
//  QuizTableViewCell.swift
//  iQuiz1
//
//  Created by Jasper Wang on 5/16/24.
//

import Foundation

import UIKit

protocol QuizTableViewCellDelegate: AnyObject {
    func didSelectQuiz(_ quiz: Quiz)
}

class QuizTableViewCell: UITableViewCell {

    weak var delegate: QuizTableViewCellDelegate?
    var quiz: Quiz?

    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupTapGesture()
    }

    private func setupViews() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        // Customize the appearance
        iconImageView.contentMode = .scaleAspectFit
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        // Layout constraints
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc private func cellTapped() {
        if let quiz = quiz {
            delegate?.didSelectQuiz(quiz)
        }
    }

    func configure(with quiz: Quiz) {
        self.quiz = quiz
        // Set the icon image (assuming you have some images to set, e.g., placeholders for each category)
        if quiz.imgName != nil {
            iconImageView.image = UIImage(named: quiz.imgName!)
        }
        // Truncate title to 30 characters if necessary
        titleLabel.text = String(quiz.title.prefix(30))

        // Set the description
        descriptionLabel.text = quiz.desc
    }
}
