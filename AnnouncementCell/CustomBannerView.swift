//ana sayfadaki gosterilen metin sayısı artsın
//satırlar arası bosluklar duzenlenecek


import UIKit

// Model sınıfını sadece description ve image içerecek şekilde güncelle
struct AnnouncementItem {
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
            
            // Page Control ve butonu CollectionView içine taşı
            // if pageControl.superview != collectionView {
            //     pageControl.removeFromSuperview()
            //     collectionView.addSubview(pageControl)
            // }
            
            // if seeAllButton.superview != collectionView {
            //     seeAllButton.removeFromSuperview()
            //     collectionView.addSubview(seeAllButton)
            // }
            
            // CollectionView'ı yapılandır
            setupCollectionView()
            
            // Butonun görünümünü ayarla
            setupButton()
            
            // Page Control ve butonun konumunu ayarla
            // setupPageControlAndButtonPosition()
            
            // Örnek verilerle doldur
            loadSampleData()
        }
    }

    // Page Control ve Buton konumlandırma metodu kaldırıldı

    
    private func setupCollectionView() {
        // Doğrudan string kullanın, 'AnnouncementCollectionViewCell.identifier' yerine
        collectionView.register(AnnouncementCollectionViewCell.self,
                  forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        //layout özellestirmeleri
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets.zero
        }
    
        // Köşeleri yuvarlat
        collectionView.layer.cornerRadius = 12
        contentView.layer.cornerRadius = 12
        
        // Paging efekti için UIPageControl'ü ayarla
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
    }

    private func setupPageControlAndButtonPosition() {
    // Page Control ve butonun konumunu programatik olarak ayarlayın
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    seeAllButton.translatesAutoresizingMaskIntoConstraints = false
    
    // Mevcut constraint'leri deaktive edin
    NSLayoutConstraint.deactivate(pageControl.constraints)
    NSLayoutConstraint.deactivate(seeAllButton.constraints)
    
    // Page Control için yeni constraint'ler
    NSLayoutConstraint.activate([
        pageControl.bottomAnchor.constraint(equalTo: seeAllButton.topAnchor, constant: -5),
        pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
        pageControl.heightAnchor.constraint(equalToConstant: 20)
    ])
    
    // Button için yeni constraint'ler
    NSLayoutConstraint.activate([
        seeAllButton.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -15),
        seeAllButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
        seeAllButton.heightAnchor.constraint(equalToConstant: 40),
        seeAllButton.leadingAnchor.constraint(greaterThanOrEqualTo: collectionView.leadingAnchor, constant: 75),
        seeAllButton.trailingAnchor.constraint(lessThanOrEqualTo: collectionView.trailingAnchor, constant: -75)
    ])
}
    
    private func setupButton() {
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Tüm duyuruları incele"
            config.image = UIImage(systemName: "arrow.right")
            config.imagePlacement = .trailing
            config.imagePadding = 8
            config.baseBackgroundColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
            config.baseForegroundColor = UIColor(red: 0.9, green: 0.88, blue: 0.96, alpha: 1.0)
            
            // Köşe yuvarlaklığını biraz azaltıyoruz (capsule'dan medium'a)
            config.cornerStyle = .medium // Daha yumuşak köşeler için
            
            config.buttonSize = .medium
            seeAllButton.configuration = config
        } else {
            // iOS 15 öncesi için eski yöntem
            seeAllButton.backgroundColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
            seeAllButton.setTitle("Tüm duyuruları incele", for: .normal)
            seeAllButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            seeAllButton.tintColor = UIColor(red: 0.9, green: 0.88, blue: 0.96, alpha: 1.0)
            
            // Köşe yuvarlaklığı için 32 değeri çok yüksek, 16 değeri daha uygun olacaktır
            seeAllButton.layer.cornerRadius = 16 // Burada değişiklik yapıldı
            
            seeAllButton.clipsToBounds = true
            seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            seeAllButton.semanticContentAttribute = .forceRightToLeft
            seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }

    // Örnek veri yükleyen metot
    private func loadSampleData() {
        //Duyurular AnnouncementDataManager dosyasından alınmaktadır.
        let sampleAnnouncements = AnnouncementDataManager.shared.announcements
        
        // Banner view'ı yapılandır.
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

    override func layoutSubviews() {
        super.layoutSubviews()

        // Buton ve page control'ü görünür hale getirmek için
        pageControl.isHidden = false
        seeAllButton.isHidden = false
        
        // Z-indeksini ayarla (kontroller hücrelerin üstünde görünsün)
        collectionView.bringSubviewToFront(pageControl)
        collectionView.bringSubviewToFront(seeAllButton)
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
        cell.configure(with:announcement.description, imageName: announcement.imageName)
        return cell
    }
    
    // Hücre boyutunu collectionView boyutuna eşitle (tam sayfa paging için) //private kaldırıldı
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // CollectionView'ın tam genişliği ve uygun bir yükseklik
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 80) // 80px, page control ve buton için ayrılan alan
    }

    // Page control güncellemesi için metod ekleyin
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == collectionView) {
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int(floor(scrollView.contentOffset.x / pageWidth))
            pageControl.currentPage = currentPage
        }
    }
}
