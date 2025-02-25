import UIKit

class CustomBannerView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    private var timer: Timer?
    private var currentPage = 0
    
    var announcements: [Announcement] = [
        Announcement(icon: "megaphone", text: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir."),
        Announcement(icon: "gift", text: "Yılbaşına özel indirimler başladı!"),
        Announcement(icon: "bell", text: "Yeni ürünlerimiz mağazalarımızda sizleri bekliyor.")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // XIB dosyasını yükle
        Bundle.main.loadNibNamed("CustomBannerView", owner: self)
        addSubview(contentView)
        
        // ContentView constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupUI()
        setupCollectionView()
        startTimer()
    }
    
    private func setupUI() {
        // View ayarları
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.973, alpha: 1.0)
        
        // CollectionView ayarları
        collectionView.backgroundColor = .clear
        
        // PageControl ayarları
        pageControl.numberOfPages = announcements.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.365, green: 0.247, blue: 0.737, alpha: 1.0)
        
        // Button ayarları
        seeAllButton.backgroundColor = UIColor(red: 0.369, green: 0.243, blue: 0.737, alpha: 1.0)
        seeAllButton.setTitleColor(UIColor(red: 0.902, green: 0.878, blue: 0.961, alpha: 1.0), for: .normal)
        seeAllButton.layer.cornerRadius = 8
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 12)
        seeAllButton.setTitle("Tüm duyuruları incele", for: .normal)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // XIB'den cell'i register et
        let nib = UINib(nibName: "AnnouncementCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.isPagingEnabled = true
        
        // CollectionView Layout
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            // Cell boyutunu CollectionView boyutuna eşitle
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            layout.estimatedItemSize = .zero
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.moveToNextPage()
        }
    }
    
    private func moveToNextPage() {
        currentPage = (currentPage + 1) % announcements.count
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentPage
    }
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        // TODO: Implement navigation to all announcements
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension CustomBannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCell
        let announcement = announcements[indexPath.item]
        cell.configure(with: announcement)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentPage = page
        pageControl.currentPage = page
    }
}
