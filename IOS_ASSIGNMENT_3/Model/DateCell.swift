import UIKit
class DateCell: UICollectionViewCell {
    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        contentView.addSubview(button)
        button.frame = contentView.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Customize the appearance of the button

        let pink = UIColor(red: 254/255, green: 58/255, blue: 92/255, alpha: 1.0)
        button.setTitleColor(pink, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
      
    }

    func setupCell(day: Int) {
        button.setTitle("\(day)", for: .normal)
    }
}
