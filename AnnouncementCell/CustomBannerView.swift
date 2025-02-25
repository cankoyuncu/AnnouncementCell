import UIKit

class CustomBannerView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    private var timer: Timer?
    private var currentPage = 0
    
    var announcements: [Announcement] = [
        Announcement(icon: "exclamationmark.triangle.fill", text: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir."),
        Announcement(icon: "gift.fill", text: "Yılbaşına özel indirimler başladı!"),
        Announcement(icon: "bell.fill", text: "Yeni ürünlerimiz mağazalarımızda sizleri bekliyor.")
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
        if let view = Bundle.main.loadNibNamed("CustomBannerView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
            setupUI()
            setupCollectionView()
            startTimer()
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.973, alpha: 1.0)
        
        pageControl.numberOfPages = announcements.count
        pageControl.currentPage = 0
        
        seeAllButton.backgroundColor = UIColor(red: 0.369, green: 0.243, blue: 0.737, alpha: 1.0)
        seeAllButton.setTitleColor(.white, for: .normal)
        seeAllButton.layer.cornerRadius = 8
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AnnouncementCell.self, forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.isPagingEnabled = true
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
