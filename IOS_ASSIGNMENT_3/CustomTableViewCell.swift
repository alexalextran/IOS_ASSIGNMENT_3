import UIKit
class CustomTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let entryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        entryLabel.font = UIFont.systemFont(ofSize: 17)
        entryLabel.textColor = .black
        entryLabel.numberOfLines = 0
        entryLabel.lineBreakMode = .byWordWrapping
        entryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(entryLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            entryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            entryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            entryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            entryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
