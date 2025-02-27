import UIKit

public class AnnouncementCollectionViewCell: UICollectionViewCell {
    
    // Identifier ekliyorum
    public static let identifier = "AnnouncementCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // containerView constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // imageView constraints - Sol üst köşede
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 35),  // İkon boyutu
            imageView.heightAnchor.constraint(equalToConstant: 35), // İkon boyutu
            
            // titleLabel constraints - İkonun yanında ve üstte
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            // descriptionLabel constraints - Başlığın altında ikona göre hizalı
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12), // İkon ile aynı hizada sol kenar
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15)
        ])
        
        // Görünümü geliştirmek için stil ayarları
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowRadius = 6
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 5  // Daha fazla satır göstermesine izin verin
        descriptionLabel.textAlignment = .left
    }

    // configure metodunu güncelleyerek standart bir ikon kullanıyoruz ve title'ı gizliyoruz

    public func configure(with description: String, imageName: String) {
        // Title etiketini view hiyerarşisinden kaldır
        titleLabel.removeFromSuperview()
            
            // Açıklama metni için konumlandırma

            NSLayoutConstraint.deactivate(descriptionLabel.constraints)
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
                descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
                descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
                descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15)
            ])
        
            // Acıklama metni ayarla
            descriptionLabel.text = description

            // Standart mor duyuru ikonu kullan
            imageView.image = UIImage(systemName: "megaphone.fill") // SF Symbol kullanıyoruz benzer bir ikon için
            imageView.tintColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0) // Mor renk #5D3EBC
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFit
        
    }
    
    // public erişim belirteci ekledim
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        descriptionLabel.text = nil
    }
}
