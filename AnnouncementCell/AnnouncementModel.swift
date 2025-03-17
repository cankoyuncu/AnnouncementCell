//
//  AnnouncementModel.swift
//  AnnouncementCell
//
//  Created by can.koyuncu on 10.03.2025.
//

import Foundation

// Duyuru modeli - API'den gelen
struct Announcement: Codable {
    let id: Int
    let title, channel, validityStartDate, validityEndDate: String
    let text: String
    
    // ImageName için yardımcı özellik
    var imageName: String {
        return "announcement" // Tüm duyurular için aynı ikonu kullanıyoruz
    }
}