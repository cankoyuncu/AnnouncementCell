//Tüm duyuruları incele butonuna tıklandıktan sonra burası calisir.

import UIKit

class AnnouncementsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var announcements: [AnnouncementItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tüm Duyurular"
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        
        setupTableView()
        loadAnnouncements()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // TableView için Auto Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // TableView'ı kaydet ve delegeyi ayarla
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: "AnnouncementTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // TableView'ın yüksekliğini otomatik ayarla
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func loadAnnouncements() {
        // ViewController'dan alınabilecek örnek duyurular
        announcements = [
            AnnouncementItem(
                title: "Üyelik Avantajı",
                description: "Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz!",
                imageName: "campaign"
            ),
            AnnouncementItem(
                title: "Bakım Duyurusu",
                description: "15 Mart Cuma gecesi 02:00-04:00 saatleri arasında sistemlerimiz bakımda olacağından hizmet veremeyeceğiz.",
                imageName: "maintenance"
            ),
            AnnouncementItem(
                title: "Yeni Koleksiyon",
                description: "Bahar koleksiyonumuz tüm mağazalarımızda ve online platformumuzda sizleri bekliyor. Şık ve rahat modeller!",
                imageName: "new_products"
            ),
            AnnouncementItem(
                title: "Görüşünüz Önemli",
                description: "Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın.",
                imageName: "survey"
            ),
            AnnouncementItem(
                title: "Kargo Bildirimi",
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz.",
                imageName: "campaign"
            ),
            AnnouncementItem(
                title: "Tatil Günleri",
                description: "29-30 Ekim tarihleri arasında müşteri hizmetlerimiz kapalı olacaktır. Acil talepleriniz için e-posta adresimize yazabilirsiniz.",
                imageName: "maintenance"
            )
        ]
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AnnouncementsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableCell", for: indexPath) as! AnnouncementTableViewCell
        
        let announcement = announcements[indexPath.row]
        cell.configure(with: announcement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - AnnouncementTableViewCell
class AnnouncementTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Container view ayarları
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // İkon ayarları
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        // Başlık ayarları
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Açıklama ayarları
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        // Auto Layout constraints
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // İkon
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            
            // Başlık
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            // Açıklama
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
    }
    
    func configure(with announcement: AnnouncementItem) {
        // Başlık ayarla
        if announcement.title.isEmpty {
            titleLabel.isHidden = true
            
            // Başlık yoksa, açıklama metni için farklı konumlandırma
            descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        } else {
            titleLabel.isHidden = false
            titleLabel.text = announcement.title
        }
        
        // Açıklama ayarla
        descriptionLabel.text = announcement.description
        
        // İkon ayarla
        if let image = UIImage(named: announcement.imageName) {
            iconImageView.image = image
        } else {
            // Duyuru türüne göre farklı ikonlar ve renkler
            var iconName = "bell.fill"
            var iconColor = UIColor.systemPurple
            
            if announcement.imageName.contains("campaign") {
                iconName = "tag.fill"
                iconColor = .systemRed
            } else if announcement.imageName.contains("maintenance") {
                iconName = "wrench.fill"
                iconColor = .systemOrange
            } else if announcement.imageName.contains("new_products") {
                iconName = "gift.fill"
                iconColor = .systemGreen
            } else if announcement.imageName.contains("survey") {
                iconName = "text.bubble.fill"
                iconColor = .systemBlue
            }
            
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.tintColor = iconColor
            iconImageView.contentMode = .scaleAspectFit
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
}
