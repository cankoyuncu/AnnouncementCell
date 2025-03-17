//Tüm duyuruları incele butonuna tıklandıktan sonra burası calisir.

import UIKit

class AnnouncementsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var announcements: [Announcement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tüm Duyurular"
        view.backgroundColor = UIColor(red: 246/255.0, green: 247/255.0, blue: 249/255.0, alpha: 1.0) // #F6F7F9
        
        setupTableView()
        loadAnnouncements()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        // TableView arka plan rengi
        tableView.backgroundColor = UIColor(red: 246/255.0, green: 247/255.0, blue: 249/255.0, alpha: 1.0) // #F6F7F9
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
        //DataManager'dan verileri al
        announcements = AnnouncementDataManager.shared.announcements
        
        //TableView'ı guncelle
        tableView.reloadData()
    }
    
    // Tarih formatlamayı gerçekleştirecek yardımcı fonksiyon
    private func formatAnnouncementDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "tr_TR")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AnnouncementsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableCell", for: indexPath) as! AnnouncementTableViewCell
        
        
        // Duyuru verisini al
        let announcement = announcements[indexPath.row]
           
        // Hücreyi yapılandır
        cell.configure(with: announcement)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Tahmini yükseklik
    }
}

// MARK: - AnnouncementTableViewCell
class AnnouncementTableViewCell: UITableViewCell {
    
    // UI elemanları
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let descriptionLabel = UILabel()
    // Tarih etiketini yoruma alarak veya tamamen kaldırarak UI'da görünmesini engelliyoruz
    // private let dateLabel = UILabel() 
    
    // Saklanan constraint referansları
    private var descriptionTopConstraint: NSLayoutConstraint!
    private var descriptionBottomConstraint: NSLayoutConstraint!
    private var descriptionLeadingConstraint: NSLayoutConstraint!
    private var descriptionTrailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        // Hücre ayarları
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .clear
        
        // Container view ayarları
        containerView.backgroundColor = UIColor(red: 246/255.0, green: 247/255.0, blue: 249/255.0, alpha: 1.0)
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowColor = UIColor.clear.cgColor
        containerView.layer.shadowOpacity = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(containerView)
        
        // İkon ayarları
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)
        
        // Açıklama ayarları
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        // Tarih etiketi ayarlarını kaldırdık
        
        // Container view constraint'leri
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // İkon constraint'leri
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        // Açıklama etiketi için constraint'ler - artık iconImageView'ın yanından başlayacak
        descriptionTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        descriptionLeadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
        descriptionTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        descriptionBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        
        NSLayoutConstraint.activate([
            descriptionTopConstraint,
            descriptionLeadingConstraint,
            descriptionTrailingConstraint,
            descriptionBottomConstraint
        ])
    }
    
    func configure(with announcement: Announcement) {
        // Açıklama metnini ayarla
        descriptionLabel.text = announcement.text
        
        // İkon ayarla
        iconImageView.image = UIImage(named: "announcement")
        iconImageView.tintColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
        
        contentView.layoutIfNeeded()
    }
    
    // Tarih bilgisi içeren configureWithDetails metodunu artık kullanmıyoruz
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // İçeriği sıfırla
        iconImageView.image = nil
        descriptionLabel.text = nil
    }
}
