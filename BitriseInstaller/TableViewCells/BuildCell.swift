import UIKit

class BuildCell: UITableViewCell {

    static let reuseIdentifier = "BuildCell"

    static let preferredHeight: CGFloat = 100

    let headerLabel = UILabel()

    let bodyLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.font = UIFont.default(size: 14)
        headerLabel.textColor = UIColor.Text.gray

        bodyLabel.font = UIFont.default(size: 17, style: .light)
        bodyLabel.textColor = UIColor.Text.black

        contentView.addSubview(headerLabel)
        contentView.addSubview(bodyLabel)

        headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 9).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -9).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 9).isActive = true
        bodyLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -9).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for build: Build) {
        headerLabel.text = "Build #\(build.buildNumber)"
        bodyLabel.text = "Workflow \(build.triggeredWorkflow)"
        backgroundColor =
            build.status == .finishedWithSuccess ?
                .success :
                .failure
    }

}

