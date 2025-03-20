import UIKit

protocol CustomBannerViewDelegate: AnyObject {
    func didTapSeeAllAnnouncements(withCurrentAnnouncement text: String)
}

class CustomBannerView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var seeAllButton: UIButton!
    
    weak var delegate: CustomBannerViewDelegate?
    private var announcements: [Announcement] = []
    private var autoScrollTimer: Timer?
    private let autoScrollInterval: TimeInterval = 5.0

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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomBannerView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
            view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            setupCollectionView()
            setupButton()
            loadSampleData()
            startAutoScrollTimer()
        }
    }

    private func startAutoScrollTimer() {
        stopAutoScrollTimer()
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: autoScrollInterval,
            target: self,
            selector: #selector(scrollToNextAnnouncement),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopAutoScrollTimer() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    @objc private func scrollToNextAnnouncement() {
        guard !announcements.isEmpty else { return }

        let currentPage = pageControl.currentPage
        let nextPage = (currentPage + 1) % announcements.count
        pageControl.currentPage = nextPage

        let indexPath = IndexPath(item: nextPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    private func setupCollectionView() {
        collectionView.register(AnnouncementCollectionViewCell.self, forCellWithReuseIdentifier: "AnnouncementCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.sectionInset = UIEdgeInsets.zero
        }

        collectionView.layer.cornerRadius = 12
        contentView.layer.cornerRadius = 12

        setupPageControl()
    }

    private func setupPageControl() {
        pageControl.removeFromSuperview()
        
        let newPageControl = UIPageControl()
        pageControl = newPageControl
        
        contentView.addSubview(pageControl)
        
        pageControl.numberOfPages = announcements.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.systemGray4
        pageControl.currentPageIndicatorTintColor = UIColor.systemPurple
        pageControl.hidesForSinglePage = false
        pageControl.isUserInteractionEnabled = true
        
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .minimal
            pageControl.allowsContinuousInteraction = false
        }
        
        pageControl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: seeAllButton.topAnchor, constant: -16),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        
        pageControl.isHidden = false
        contentView.bringSubviewToFront(pageControl)
    }

    @objc private func pageControlValueChanged() {
        let currentPage = pageControl.currentPage
        
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        stopAutoScrollTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startAutoScrollTimer()
        }
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
            config.cornerStyle = .medium
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                return outgoing
            }
            config.buttonSize = .medium
            seeAllButton.configuration = config
        } else {
            seeAllButton.backgroundColor = UIColor(red: 0.37, green: 0.24, blue: 0.74, alpha: 1.0)
            seeAllButton.setTitle("Tüm duyuruları incele", for: .normal)
            seeAllButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            seeAllButton.tintColor = UIColor(red: 0.9, green: 0.88, blue: 0.96, alpha: 1.0)
            seeAllButton.layer.cornerRadius = 16
            seeAllButton.clipsToBounds = true
            seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            seeAllButton.semanticContentAttribute = .forceRightToLeft
            seeAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        }
    }

    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        guard announcements.indices.contains(pageControl.currentPage) else { 
            return    
        }

        let currentAnnouncement = announcements[pageControl.currentPage]

        let text = currentAnnouncement.text
        
        delegate?.didTapSeeAllAnnouncements(withCurrentAnnouncement: text)
        
    }

    private func loadSampleData() {
        let sampleAnnouncements = AnnouncementDataManager.shared.announcements
        configure(with: sampleAnnouncements)
    }

    public func configure(with announcements: [Announcement]) {
        self.announcements = announcements
        
        pageControl.numberOfPages = announcements.count
        pageControl.currentPage = 0
        pageControl.isHidden = announcements.count <= 1
        
        collectionView.reloadData()

        if announcements.count > 0 {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
            }
        }

        startAutoScrollTimer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.isHidden = false
        seeAllButton.isHidden = false
        
        bringSubviewToFront(pageControl)
        bringSubviewToFront(seeAllButton)
    }
}

extension CustomBannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnouncementCell", for: indexPath) as! AnnouncementCollectionViewCell
        let announcement = announcements[indexPath.item]
        cell.configure(with: announcement.text, imageName: announcement.imageName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = page
        
        startAutoScrollTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrollTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
