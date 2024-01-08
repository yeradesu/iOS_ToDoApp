import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: - UI PROPERTIES
    var circleImage = UIImageView()
    var checkmark = UIImageView()
    var nameLabel = UILabel()
    var detailLabel = UILabel()
    
    // MARK: - PROPERTIES
    var isChecked = false
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // PRIVATE FUNCTION
    private func configureCell() {
        addSubview(circleImage)
        addSubview(checkmark)
        addSubview(nameLabel)
        addSubview(detailLabel)
        
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            circleImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            circleImage.widthAnchor.constraint(equalToConstant: 20),
            circleImage.heightAnchor.constraint(equalToConstant: 20),
            
            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: circleImage.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            detailLabel.leadingAnchor.constraint(equalTo: circleImage.trailingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // PUBLIC FUNCTIONS
    func toggleImage() {
        isChecked = !isChecked
        circleImage.image = isChecked ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
    
    func configureWithTask(_ task: AddTask) {
        nameLabel.text = task.taskTitle
        detailLabel.text = task.taskDetail
        toggleImage(isChecked: task.isChecked)
    }

    func toggleImage(isChecked: Bool) {
        self.isChecked = isChecked
        circleImage.image = isChecked ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
}
