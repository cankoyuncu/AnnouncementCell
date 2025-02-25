import UIKit

class AnnouncementCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.369, green: 0.243, blue: 0.737, alpha: 1.0)
        
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 14)
        textLabel.textColor = .black
    }
    
    func configure(with announcement: Announcement) {
        iconImageView.image = UIImage(systemName: announcement.icon)
        textLabel.text = announcement.text
    }
}

struct Announcement {
    let icon: String
    let text: String
}
