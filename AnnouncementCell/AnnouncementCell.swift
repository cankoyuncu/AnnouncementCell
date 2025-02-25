import UIKit

class AnnouncementCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Icon ayarları
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.369, green: 0.243, blue: 0.737, alpha: 1.0)
        
        // Label ayarları
        textLabel.numberOfLines = 0
        textLabel.font = .systemFont(ofSize: 14)
        
        // Layout
        addSubview(iconImageView)
        addSubview(textLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
