//Announcement tanımını kaldırıyoruz çünkü artık AnnouncementModel.swift'te tanımlandı


import UIKit

protocol CustomBannerViewDelegate: AnyObject {
    func didTapSeeAllAnnouncements(withCurrentAnnouncement text: String)
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
    private var announcements: [Announcement] = []

    // Otomatik kaydırma icin zamanlayıcı ekliyoruz
    private var autoScrollTimer: Timer?
    private let autoScrollInterval: TimeInterval = 5.0

    // Deinit ekleyip hafiza sızıntısını önlüyoruz.
    deinit {
        stopAutoScrollTimer()
    }
    
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
            startAutoScrollTimer()
        }
    }

    //zamanlayici baslatiliyior
    private func startAutoScrollTimer() {
        // Zamanlayıcı zaten varsa, önce durdurun
        stopAutoScrollTimer()
        
        // Yeni bir zamanlayıcı oluşturun
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: autoScrollInterval,
            target: self,
            selector: #selector(scrollToNextAnnouncement),
            userInfo: nil,
            repeats: true
        )
    }

    //zamanlayici durdurma
    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    //sonraki duyuruya gecme
    @objc private func scrollToNextAnnouncement() {
        guard !announcements.isEmpty else { return }

        //mevcut sayfayı alın ve bir sonraki sayfaya geçin
        let currentPage = pageControl.currentPage
        let nextPage = (currentPage + 1) % announcements.count

        // Page control'u guncelle
        pageControl.currentPage = nextPage

        //Hucreyi yeniden yuklemek yerine sadece icerigini guncelle
        if let visibleCell = collectionView.visibleCells.first as? AnnouncementCollectionViewCell {
            let announcement = announcements[nextPage]
            //Mevcut hucrenin icerigini guncelle
            visibleCell.configure(with: announcement.text, imageName: announcement.imageName)
        }
        // Kaydırma kodunu tamamen kaldırdık, çünkü artık kaydırma yapmıyoruz
    }

    private func setupCollectionView() {
        // Doğrudan string kullanın, 'AnnouncementCollectionViewCell.identifier' yerine
        collectionView.register(AnnouncementCollectionViewCell.self,
                  forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        //Kullanıcının hucreyi kaydirmasini engellemek icin:
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false

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
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }

    // Page Control degistiginde cagrilacak metot
    @objc private func pageControlValueChanged() {
        let currentPage = pageControl.currentPage

        // Hucreyi yeniden yuklemek yerine sadece icerigini guncelle
        if let visibleCell = collectionView.visibleCells.first as? AnnouncementCollectionViewCell,
            announcements.indices.contains(currentPage) {
            let announcement = announcements[currentPage]
            visibleCell.configure(with: announcement.text, imageName: announcement.imageName)
        }
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
            config.cornerStyle = .medium // Daha yumuşak köşeler için
            
            // Font boyutu: 12px 
            config.titleTextAttributesTransformer =  UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                return outgoing
            }
            config.buttonSize = .medium
            seeAllButton.configuration = config
        } else {
            // iOS 15 öncesi için eski yöntem
            seeAllButton.backgroundColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
            seeAllButton.setTitle("Tüm duyuruları incele", for: .normal)
            seeAllButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            seeAllButton.tintColor = UIColor(red: 0.9, green: 0.88, blue: 0.96, alpha: 1.0)
            
            seeAllButton.layer.cornerRadius = 16    
            seeAllButton.clipsToBounds = true

            //Font 12px
            seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)

            seeAllButton.semanticContentAttribute = .forceRightToLeft
            seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }

    private func loadSampleData() {
        //Duyurular AnnouncementDataManager dosyasından alınmaktadır.
        let sampleAnnouncements = AnnouncementDataManager.shared.announcements
        
        // Banner view'ı yapılandır.
        configure(with: sampleAnnouncements)
    }
    
    public func configure(with announcements: [Announcement]) {
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

        // Duyurular degistinde zamanlayici yeniden baslat
        startAutoScrollTimer()
    }

    // Kullanıcı manuel kaydırma yaptığında zamanlayıcıyı sıfırla
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Kullanıcı kaydırma yaparsa zamanlayıcıyı durdur
        stopAutoScrollTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            // Sayfayı güncelle
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int(floor(scrollView.contentOffset.x / pageWidth))
            pageControl.currentPage = currentPage
            
            // Kullanıcının kaydırması bittikten sonra zamanlayıcıyı yeniden başlat
            startAutoScrollTimer()
        }
    }

    // Görünüm ağaçtan çıkarıldığında zamanlayıcıyı durdur
    override func removeFromSuperview() {
        super.removeFromSuperview()
        stopAutoScrollTimer()
    }
    
    // Uygulama arka plana gittiğinde zamanlayıcıyı durdur
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            // Görünüm ekrana eklendiğinde zamanlayıcıyı başlat
            startAutoScrollTimer()
        } else {
            // Görünüm ekrandan kaldırıldığında zamanlayıcıyı durdur
            stopAutoScrollTimer()
        }
    }
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        print("Tüm duyurular butonuna tıklandı")
        
        let currentPage = pageControl.currentPage
        if currentPage < announcements.count {
            let announcement = announcements[currentPage]
            delegate?.didTapSeeAllAnnouncements(withCurrentAnnouncement: announcement.text)
        } else {
            delegate?.didTapSeeAllAnnouncements(withCurrentAnnouncement: "")
        }
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

// Array uzantısını sınıfın içinden çıkarın
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
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
        cell.configure(with:announcement.text, imageName: announcement.imageName)
        return cell
    }
    
    // Hücre boyutunu collectionView boyutuna eşitle (tam sayfa paging için) //private kaldırıldı
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // CollectionView'ın tam genişliği ve uygun bir yükseklik
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 80) // 80px, page control ve buton için ayrılan alan
    }
}
