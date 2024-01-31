//
//  Model.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import Foundation

public struct Transaction: Codable, Identifiable {
  public var id: Int
  public var created_at: Int
  public var type: String
  public var amount: Double
}

extension Transaction {
  var createdAtDate: String {
    created_at.dateString
  }
}

extension Int {
  var dateString: String {
    let myTimeInterval = TimeInterval(self)
    let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval/1000))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    return dateFormatter.string(from: time as Date)
  }

  var dateSince1970: Date {
    let myTimeInterval = TimeInterval(self)
    let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval/1000))
    return time as Date
  }
}

public enum BKError: Error {
  case invalidURL
  case invalidResponse
  case networkError
}
