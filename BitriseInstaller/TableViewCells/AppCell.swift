import UIKit

class AppCell: UITableViewCell {

    static let reuseIdentifier = "AppCell"

    static let preferredHeight: CGFloat = 100

    let orgNameLabel = UILabel()

    let appNameLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        orgNameLabel.translatesAutoresizingMaskIntoConstraints = false

        orgNameLabel.font = UIFont.default(size: 14)
        orgNameLabel.textColor = UIColor.Text.gray

        appNameLabel.font = UIFont.default(size: 17, style: .light)
        appNameLabel.textColor = UIColor.Text.black

        contentView.addSubview(orgNameLabel)
        contentView.addSubview(appNameLabel)

        orgNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9).isActive = true
        orgNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 9).isActive = true
        orgNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -9).isActive = true

        appNameLabel.topAnchor.constraint(equalTo: orgNameLabel.bottomAnchor, constant: 4).isActive = true
        appNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 9).isActive = true
        appNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -9).isActive = true
        appNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for app: App) {
        orgNameLabel.text = app.owner.name
        appNameLabel.text = app.title
    }

}
