//
//  APIManager.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import Foundation

public struct APIManager {
  public func getTransactions() async throws -> [Transaction] {
    let transactionUrl = URL(string: "https://x8ki-letl-twmt.n7.xano.io/api:O8qF4MsJ/transactions")

    guard let transactionUrl = transactionUrl else {
      throw BKError.invalidURL
    }

    do {
      let (data, response) = try await URLSession.shared.data(from: transactionUrl)
      guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
        throw BKError.invalidResponse
      }

      let transactions = try JSONDecoder().decode([Transaction].self, from: data)

      return transactions
    } catch {
      throw BKError.networkError
    }
  }
}
