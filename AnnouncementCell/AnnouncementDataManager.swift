// Duyuru metinleri buradan yonetilir.

// Bu sınıf, uygulama genelinde kullanılacak duyuru verilerini merkezi olarak yönetir.
// Böylece hem ana sayfada hem de tüm duyurular sayfasında aynı duyurular kullanılabilir.

import Foundation

class AnnouncementDataManager {
    
    // Singleton yapısı ile her yerden erişilebilir bir yapı oluşturuyoruz
    static let shared = AnnouncementDataManager()
    
    // Tüm duyuruların listesi
    private(set) var announcements: [AnnouncementItem] = []
    
    // İlk oluşturulduğunda duyuruları yükleyen özel initializer
    private init() {
        loadAnnouncements()
    }
    
    // Duyuruları yükleyen fonksiyon. Title kaldırıldı.
    private func loadAnnouncements() {
        announcements = [
            AnnouncementItem(
                description: "Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz! Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz! Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz! Yeni üyelerimize özel ilk alışverişte %30 indirim ve ücretsiz kargo ayrıcalığı sunuyoruz!",
                imageName: "announcement" //Tüm ikonlar "announcement" olarak standardize edildi
            ),
            AnnouncementItem(
                description: "15 Mart Cuma gecesi 02:00-04:00 saatleri arasında sistemlerimiz bakımda olacağından hizmet veremeyeceğiz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Bahar koleksiyonumuz tüm mağazalarımızda ve online platformumuzda sizleri bekliyor. Şık ve rahat modeller!",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "29-30 Ekim tarihleri arasında müşteri hizmetlerimiz kapalı olacaktır. Acil talepleriniz için e-posta adresimize yazabilirsiniz. 29-30 Ekim tarihleri arasında müşteri hizmetlerimiz kapalı olacaktır. Acil talepleriniz için e-posta adresimize yazabilirsiniz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz. 29-30 Ekim tarihleri arasında müşteri hizmetlerimiz kapalı olacaktır. Acil talepleriniz için e-posta adresimize yazabilirsiniz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz.",
                imageName: "announcement"
            ),
        ]
    }
    
    // Daha sonra eklenebilecek yeni duyuruları eklemek için fonksiyon
    // Yeni duyuru eklemek için fonksiyon - title parametresi boş string olarak ayarlandı
        func addAnnouncement(description: String) {
            let announcement = AnnouncementItem(description: description, imageName: "announcement")
            announcements.append(announcement)
        }
    
    // Duyurular listesini temizleyip yeniden yüklemek için fonksiyon
    func resetAnnouncements() {
        announcements.removeAll()
        loadAnnouncements()
    }
}
