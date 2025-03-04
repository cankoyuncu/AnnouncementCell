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
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Lorem ipsum dolor Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir.",
                imageName: "announcement" //Tüm ikonlar "announcement" olarak standardize edildi
            ),
            AnnouncementItem(
                description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Bahar koleksiyonumuz tüm mağazalarımızda ve online platformumuzda sizleri bekliyor. Şık ve rahat modeller!",
                imageName: "announcement"
            ),
            AnnouncementItem(
                description: "Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın. Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın.",
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
                description: "Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Anlayışınız için teşekkür ederiz. Hizmet kalitemizi artırmak için görüşleriniz bizim için çok değerli. Ankete katılarak fikirlerinizi bizimle paylaşın.",
                imageName: "announcement"
            ),
        ]
    }
    
    // Daha sonra eklenebilecek yeni duyuruları eklemek için fonksiyon
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
