//
//  detail.swift
//  UserLocation
//
//  Created by andy on 2022/12/6.
//
import Foundation




struct details: Decodable {
    let id: String
    let title: String?
    let artist: String?
    let info: String?
    let thumbnail: String?
    let lat: String?
    let lon: String?
    let enabled: String?
    let lastModified: String?
    let images: [imagedetail]

    
}

struct newbrighton: Decodable {
    let newbrighton_murals: [details]
}

struct imagedetail: Decodable {
    let id: String?
    let filename: String?
}




