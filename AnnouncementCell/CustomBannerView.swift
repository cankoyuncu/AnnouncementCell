import UIKit

// Model sınıfını ekleyelim
struct AnnouncementItem {
    let title: String
    let description: String
    let imageName: String
}

protocol CustomBannerViewDelegate: AnyObject {
    func didTapSeeAllAnnouncements()
}

class CustomBannerView: UIView {
    
    // XIB ile eşleşen outlet'ler
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    // Delegate özelliği
    weak var delegate: CustomBannerViewDelegate?
    
    // Announcement verileri
    private var announcements: [AnnouncementItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // XIB dosyasını yükle
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomBannerView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
            view.translatesAutoresizingMaskIntoConstraints = false  // autoresizingMaskIntoConstraints yerine bu kullanılmalı
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            // CollectionView'ı yapılandır
            setupCollectionView()
            
            // Butonun görünümünü ayarla
            setupButton()
            
            // Örnek verilerle doldur
            loadSampleData()
        }
    }
    
    private func setupCollectionView() {
        // Doğrudan string kullanın, 'AnnouncementCollectionViewCell.identifier' yerine
        collectionView.register(AnnouncementCollectionViewCell.self,
                  forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    
        // Köşeleri yuvarlat
        collectionView.layer.cornerRadius = 12
        contentView.layer.cornerRadius = 12
        
        // Paging efekti için UIPageControl'ü ayarla
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
    }
    
    private func setupButton() {
        seeAllButton.backgroundColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
        seeAllButton.setTitle("Tüm duyuruları incele", for: .normal)
        seeAllButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        seeAllButton.tintColor = UIColor(red: 0.9, green: 0.88, blue: 0.96, alpha: 1.0)
        seeAllButton.layer.cornerRadius = 16
        seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        // Butonun sağ tarafına ikon eklemek için
        seeAllButton.semanticContentAttribute = .forceRightToLeft
        seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }

    // Örnek veri yükleyen metot
    private func loadSampleData() {
        let sampleAnnouncements = [
            AnnouncementItem(
                title: "Yeni Yıl Kampanyası",
                description: "Yeni yıla özel tüm ürünlerde %25 indirim fırsatını kaçırmayın!",
                imageName: "announcement1"
            ),
            AnnouncementItem(
                title: "Sistem Bakımı Bildirimi",
                description: "15 Mart Cuma gecesi 02:00-05:00 arası sistemlerimiz bakımda olacaktır",
                imageName: "announcement2"
            ),
            AnnouncementItem(
                title: "Mobil Uygulama Güncellemesi",
                description: "Uygulamamızın yeni sürümünde artık tek tıkla ödeme yapabilirsiniz",
                imageName: "announcement3"
            ),
            AnnouncementItem(
                title: "Yeni Mağaza Açılışı",
                description: "İzmir'deki yeni mağazamız 1 Nisan'da sizlerle buluşuyor! Açılışa özel indirimler sizleri bekliyor.",
                imageName: "announcement4"
            )
        ]
        
        configure(with: sampleAnnouncements)
    }
    
    public func configure(with announcements: [AnnouncementItem]) {
        self.announcements = announcements
        pageControl.numberOfPages = announcements.count
        collectionView.reloadData()
        
        // CollectionView yüklendikten sonra ilk sayfayı göster
        if announcements.count > 0 {
            pageControl.currentPage = 0
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        print("Tüm duyurular butonuna tıklandı")
        delegate?.didTapSeeAllAnnouncements()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension CustomBannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Doğrudan string kullanın
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCollectionViewCell
        
        let announcement = announcements[indexPath.item]
        cell.configure(with: announcement.title, description: announcement.description, imageName: announcement.imageName)
        return cell
    }
    
    // Hücre boyutunu collectionView boyutuna eşitle (tam sayfa paging için)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    // Sayfa değişimini takip et ve page control'ü güncelle
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
