import UIKit

class ViewController: UIViewController {
    
    private var bannerView: CustomBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerView()
    }
    
    private func setupBannerView() {
        // XIB'den banner view'ı yükle
        bannerView = CustomBannerView(frame: .zero)
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
        view.backgroundColor = .white
    }
}