//Announcement Ana Sayfa

import UIKit

public class AnnouncementCollectionViewCell: UICollectionViewCell {
    
    // Identifier ekliyorum
    public static let identifier = "AnnouncementCell"
    
    // containerView için arka plan rengi ayarı
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 240/255.0, green: 241/255.0, blue: 247/255.0, alpha: 1.0) //rgb(149, 149, 149)
        view.layer.cornerRadius = 10

        //Golge ozellikleri kaldırılıyor.
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 0

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
        // Container view ayarları
        containerView.backgroundColor = UIColor(red: 246/255.0, green: 247/255.0, blue: 249/255.0, alpha: 1.0) // #F6F7F9
        
        // Container view'ı ekle
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // containerView constraints
            // containerView.heightAnchor.constraint(lessThanOrEqualToConstant: 180) // Maksimum yükseklik sonradan aktiflestirebilirim
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // imageView constraints - Sol üst köşede
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 24),  // İkon boyutu
            imageView.heightAnchor.constraint(equalToConstant: 24), // İkon boyutu
            
            // descriptionLabel constraints - ilk satır ikon ile aynı hizada başlasın
            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15)
        ])
        
        // containerView için sonradan yapılan ayarlar
        containerView.backgroundColor = UIColor(red: 235/255.0, green: 236/255.0, blue: 242/255.0, alpha: 1.0) // Daha koyu #EBECF2
        containerView.layer.cornerRadius = 14
        
        descriptionLabel.numberOfLines = 6 // 6 satir icerik gozukecek sekilde ayarlandi.
        descriptionLabel.lineBreakMode = .byTruncatingTail // Sonunda ... ile kesilsin
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textAlignment = .left
    }

    // configure metodunu güncelleyerek standart bir ikon kullanıyoruz ve title'ı gizliyoruz

    public func configure(with text: String, imageName: String) {
        //Acıklama metnini set ediyorum. Bunu sadece bir kez set etmelisin. Yoksa hata.
        //Acıklama metnini kısaltarak ayarlıyorum. 
        // descriptionLabel.numberOfLines = 6 zaten setupViews() icinde ayarlanmis.
        // lineBreakMode = .byTruncaringTail ile 6.satirdan sonrasi otomatik olarak "..." ile kesilecek.

        descriptionLabel.text = text

        // Announcement mor duyuru ikonu kullan
        imageView.image = UIImage(named: "announcement") 
        imageView.tintColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0) // Mor renk #5D3EBC
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit

        // Layout update. Degisikliklerin hemen uygulanması icin.  
        layoutIfNeeded()      
    }
    
    // public erişim belirteci ekledim
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        descriptionLabel.text = nil
    }
}
