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
            bannerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        // Arka plan rengini ayarla
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0)
        
        // Duyuruları merkezi yoneticiden al
        let announcements = AnnouncementDataManager.shared.announcements
        
        // Banner view'a duyuruları gonder
        bannerView.configure(with: announcements)
    }
}

// MARK: - CustomBannerViewDelegate
extension ViewController: CustomBannerViewDelegate {
    func didTapSeeAllAnnouncements(withCurrentAnnouncement text: String) {
        let announcementsVC = AnnouncementsViewController()
        navigationController?.pushViewController(announcementsVC, animated: true)
    }
}
