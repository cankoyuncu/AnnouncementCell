// Duyuru metinleri buradan yonetilir.

// Bu sınıf, uygulama genelinde kullanılacak duyuru verilerini merkezi olarak yönetir.
// Böylece hem ana sayfada hem de tüm duyurular sayfasında aynı duyurular kullanılabilir.

import Foundation

// API'den gelen tüm response modelimiz
struct ApiResponse: Codable {
    let announcements: [Announcement]
    let id: Int?
    let rules: [Rule]?
}

// RuleCase modelini tanımlıyoruz
struct RuleCase: Codable {
    let code: String
    let id: String
    let caseData: [String: String]
    let next: String
    
    // Özel coding keys tanımlayarak JSON'daki case alanını Swift'teki caseData ile eşleştiriyoruz
    enum CodingKeys: String, CodingKey {
        case code, id, next
        case caseData = "case" // JSON'daki "case" alanını Swift'teki caseData ile eşleştir
    }
}

struct RuleAttribute: Codable {
    let key: String
    let value: String
}

// Rule yapısı (navigasyon kuralları)
struct Rule: Codable {
    let code: String
    let id: String
    let type: String
    let text_tr: String?
    let next: String?
    let children: [Rule]?
    let action: String?
    let cases: [RuleCase]?
    let attr: [RuleAttribute]?
    let button_text_tr: String?
    let no_order: String?
    let login_required: Bool?
    let link: String?
    let thumbnail_link: String?
}

class AnnouncementDataManager {
    
    // Singleton yapısı
    static let shared = AnnouncementDataManager()
    
    // Duyuruların listesi
    private(set) var announcements: [Announcement] = []
    
    // API response'u
    private(set) var apiResponse: ApiResponse?
    
    // İlk oluşturulduğunda duyuruları yükle
    private init() {
        loadJsonData()
    }
    
    // Rule'dan metin oluşturma yardımcı fonksiyonu
    func getFormattedTextFromRule(rule: Rule, userName: String? = nil) -> String {
        
        // Sadece rule.text_tr degiskenini dondurecegiz.
        
        return rule.text_tr ?? ""
    }
    
    // Rule'dan duyuru oluşturma fonksiyonu
    func createAnnouncementsFromRules() -> [Announcement] {
        guard let rules = apiResponse?.rules else { return [] }
        
        var ruleAnnouncements: [Announcement] = []
        
        // Ana kuralları dolaşarak, text_tr değeri olanları duyuru olarak ekle
        for rule in rules {
            if let text = rule.text_tr, !text.isEmpty {
                let formattedText = getFormattedTextFromRule(rule: rule)
                let announcement = Announcement(
                    id: Int.random(in: 1000...9999),
                    title: "Rule Announcement",
                    channel: "MOBILE_IOS",
                    validityStartDate: "2025-03-02T21:00:00",
                    validityEndDate: "2025-04-03T21:00:00",
                    text: formattedText
                )
                ruleAnnouncements.append(announcement)
            }
            
            // Alt kuralları da kontrol et
            if let children = rule.children {
                for childRule in children {
                    if let text_tr = childRule.text_tr, !text_tr.isEmpty {
                        let formattedText = getFormattedTextFromRule(rule: childRule)
                        let announcement = Announcement(
                            id: Int.random(in: 1000...9999), // Dummy ID 
                            title: "Rule Announcement (Child)",
                            channel: "MOBILE_IOS", 
                            validityStartDate: "2025-03-02T21:00:00",
                            validityEndDate: "2025-04-03T21:00:00",
                            text: formattedText
                        )
                        ruleAnnouncements.append(announcement)
                    }
                }
            }
        }
        
        return ruleAnnouncements
    }
    
    // JSON dosyasından veri yükleme
    private func loadJsonData() {
        // JSON string'i yükle
        let jsonString = """
        {
          "announcements": [
            {
              "id": 13,
              "title": "title",
              "channel": "MOBILE_IOS",
              "validityStartDate": "2025-03-02T21:00:00",
              "validityEndDate": "2025-04-03T21:00:00",
              "text": "1.Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme"
            },
            {
              "id": 14,
              "title": "title",
              "channel": "MOBILE_IOS",
              "validityStartDate": "2025-03-02T21:00:00",
              "validityEndDate": "2025-04-03T21:00:00",
              "text": "2.Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir. Lorem ipsum is a dummy or placeholder text commonly used in"
            },
            {
              "id": 15,
              "title": "title",
              "channel": "MOBILE_IOS",
              "validityStartDate": "2025-03-02T21:00:00",
              "validityEndDate": "2025-04-03T21:00:00",
              "text": "3.Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir."
            }
          ]
        }
        """
        
        // JSON verilerini parse et
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                apiResponse = try decoder.decode(ApiResponse.self, from: jsonData)
                
                // API'den gelen duyuruları uygulama modelimize dönüştür
                if let apiAnnouncements = apiResponse?.announcements {
                    announcements = apiAnnouncements      
                }
                
                // Rule'lardan da duyuru oluştur ve ekle
                let ruleAnnouncements = createAnnouncementsFromRules()
                announcements.append(contentsOf: ruleAnnouncements)
                
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
                print(error)
                // Hata durumunda örnek veriler yükle
                loadSampleData()
            }
        } else {
            // JSON verisi yüklenemediyse örnek veriler yükle
            loadSampleData()
        }
    }
    
    // Örnek veri yükleme (JSON parse hatası durumunda)
    private func loadSampleData() {
        announcements = [
            Announcement(
                id: 13,
                title: "title",
                channel: "MOBILE_IOS",
                validityStartDate: "2025-03-02T21:00:00",
                validityEndDate: "2025-04-03T21:00:00",
                text: "5.Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content. Kasım kampanyası nedeniyle kargolarınızda anlık gecikme yaşanabilir."
            ),
            Announcement(
                id: 14,
                title: "title",
                channel: "MOBILE_IOS",
                validityStartDate: "2025-03-02T21:00:00",
                validityEndDate: "2025-04-03T21:00:00",
                text: "6.Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty spaces in a layout that does not yet have content."
            )
        ]
    }
    
    // Yeni duyuru ekleme
    func addAnnouncement(text: String) {
        let announcement = Announcement(
            id: Int.random(in: 1000...9999),
            title: "Manuel Duyuru",
            channel: "MOBILE_IOS",
            validityStartDate: "2025-03-02T21:00:00",
            validityEndDate: "2025-04-03T21:00:00",
            text: text
        )
        announcements.append(announcement)
    }
    
    // Duyuruları sıfırla
    func resetAnnouncements() {
        announcements.removeAll()
        loadJsonData()
    }
    
    // API'den gelen ham duyuru verisine erişim
    func getRawAnnouncements() -> [Announcement]? {
        return apiResponse?.announcements
    }
}
