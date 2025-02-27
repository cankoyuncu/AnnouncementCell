import UIKit

class ViewController: UIViewController {
    
    private var bannerView: CustomBannerView!
    @IBOutlet private weak var banner: CustomBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerView()
    }
    
    private func setupBannerView() {
        // Banner view'ı oluştur
        bannerView = CustomBannerView(frame: .zero)
        bannerView.delegate = self
        view.addSubview(bannerView)
        
        // Auto Layout constraints
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bannerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Arka plan rengini ayarla
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        
        // Örnek veriler
        let announcements = [
            AnnouncementItem(
                title: "",
                description: "Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz!",
                imageName: "campaign"
            ),
            AnnouncementItem(
                title: "",
                description: "15 Mart Cuma gecesi 02:00-04:00 saatleri arasında sistemlerimiz bakımda olacağından hizmet veremeyeceğiz.",
                imageName: "maintenance"
            ),
            AnnouncementItem(
                title: "",
                description: "Bahar koleksiyonumuz tüm mağazalarımızda ve online platformumuzda sizleri bekliyor. Şık ve rahat modeller!",
                imageName: "new_products"
            ),
            AnnouncementItem(
                title: "",
                description: "Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın.",
                imageName: "survey"
            )
        ]
        
        // CustomBannerView sınıfında configure metodu olduğundan emin olun
        bannerView.configure(with: announcements)
    }
}

// MARK: - CustomBannerViewDelegate
extension ViewController: CustomBannerViewDelegate {
    func didTapSeeAllAnnouncements() {
        let announcementsVC = AnnouncementsViewController()
        navigationController?.pushViewController(announcementsVC, animated: true)
    }
}
