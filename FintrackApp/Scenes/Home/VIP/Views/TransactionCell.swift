import UIKit

final class TransactionCell: UITableViewCell {
    struct ViewModel {
        let title: String
        let amount: String
        let date: String
        let category: String
        let isIncome: Bool
    }
    
    static let reuseIdentifier = String(describing: TransactionCell.self)
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private lazy var titleAndCategoryStackView = makeStackView(with: [titleLabel, categoryNameLabel],
                                                               axis: .vertical)
    private lazy var amountAndDateStackView = makeStackView(with: [amountLabel, dateLabel],
                                                            axis: .vertical)
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        amountLabel.text = viewModel.amount
        categoryNameLabel.text = viewModel.category
        dateLabel.text = viewModel.date
        iconImageView.image = viewModel.isIncome ? UIImage(systemName: "arrow.up") : UIImage(systemName: "arrow.down")
        iconImageView.tintColor = viewModel.isIncome ? .systemGreen : .systemRed
    }
}

// MARK: - View Code
extension TransactionCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleAndCategoryStackView)
        containerView.addSubview(amountAndDateStackView)
    }
    
    func setupConstrains() {
        containerView.fillConstraints(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            bottom: contentView.bottomAnchor,
            padding: .init(top: 8, left: 16, bottom: 8, right: 16)
        )
        
        iconImageView.fillConstraints(
            top: nil,
            leading: containerView.leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0),
            size: CGSize(width: 24, height: 24)
        )
        iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        titleAndCategoryStackView.fillConstraints(
            top: contentView.topAnchor,
            leading: iconImageView.trailingAnchor,
            trailing: nil,
            bottom: contentView.bottomAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16)
        )
        
        amountAndDateStackView.fillConstraints(
            top: titleAndCategoryStackView.topAnchor,
            leading: titleAndCategoryStackView.trailingAnchor,
            trailing: containerView.trailingAnchor,
            bottom: titleAndCategoryStackView.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 16)
        )
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
