//
//  DashboardViewModel.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import Foundation
import Combine

@MainActor
public class DashboardScreenViewModel: ObservableObject {
  @Published var transactions: [Transaction] = [Transaction]()
  @Published var errorString: String?

  @Published var filterStartTimeStamp: Int?
  @Published var filterEndTimeStamp: Int?

  var filteredTransactions: [Transaction] {
    guard let startTimeStamp = filterStartTimeStamp, let endTimeStamp = filterEndTimeStamp else {
      return transactions
    }
    
    return transactions.filter { transaction in
      transaction.created_at > startTimeStamp && transaction.created_at < endTimeStamp
    }
  }

  var incomeTransactions: [Transaction] {
    filteredTransactions.filter { $0.type == "income" }
  }

  var expenseTransactions: [Transaction] {
    filteredTransactions.filter { $0.type == "expense" }
  }

  var startDate: Date {
    set(newStartDate) {
      filterStartTimeStamp = Int(newStartDate.timeIntervalSince1970 * 1000)
    }
    get {
      guard let filterStartTimeStamp = filterStartTimeStamp else {
        return Date.now
      }
      return filterStartTimeStamp.dateSince1970
    }
  }

  var startDateString: String {
    guard let filterStartTimeStamp = filterStartTimeStamp else {
      return ""
    }
    return filterStartTimeStamp.dateString
  }

  var endDate: Date {
    set(newEndDate) {
      filterStartTimeStamp = Int(newEndDate.timeIntervalSince1970 * 1000)
    }
    get {
      guard let filterEndTimeStamp = filterEndTimeStamp else {
        return Date.now
      }
      return filterEndTimeStamp.dateSince1970
    }
  }

  var endDateString: String {
    guard let filterEndTimeStamp = filterEndTimeStamp else {
      return ""
    }
    return filterEndTimeStamp.dateString
  }

  var incomeTotal: Double {
    incomeTransactions.reduce(0) { $0 + $1.amount }
  }

  var expensesTotal: Double {
    expenseTransactions.reduce(0) { $0 + $1.amount }
  }

  var balanceTotal: Double {
    incomeTotal - expensesTotal
  }

  public func loadTransactions() {
    Task {
      do {
        transactions = try await apiManager.getTransactions()

        let sorted = filteredTransactions.sorted(by: { $0.created_at < $1.created_at })
        if !sorted.isEmpty {
          filterStartTimeStamp = sorted[0].created_at
          filterEndTimeStamp = sorted[sorted.count - 1].created_at
        }

      } catch let bkError{

        switch bkError {
          case BKError.invalidURL:
            errorString = "There's something went wrong with network"
          case BKError.invalidResponse:
            errorString = "Invalid response return from server, try again later"
          default:
            errorString = "Something went wrong, please try again later."
        }
      }
    }
  }

  let apiManager: APIManager
  
  public init(apiManager: APIManager) {
    self.apiManager = apiManager
  }
}
