// Yeni bir extension dosyası olusturuyoruz
class AnnouncementCell: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // IconImageView'ın height constraint'i ambiguous hatası icin
        for constraint in constraints {
            // Bottom constraint'i varsa kaldir
            if constraint.firstItem === iconImageView && constraint.firstAttribute == .bottom {
                constraint.isActive = false
            }
        }
        
        // TextLabel için width constraint'ini kaldır (autolayout hesaplayabilsin)
        for constraint in textLabel.constraints {
            if constraint.firstAttribute == .width {
                constraint.isActive = false
            }
        }
        
        // TextLabel hizalamasını düzelt (sol tarafa)
        textLabel.textAlignment = .left
    }
}