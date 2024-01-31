//
//  DashboardView.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import SwiftUI
import Charts

struct DashboardScreen: View {
  @StateObject var viewModel = DashboardScreenViewModel(apiManager: APIManager())

  @State private var startDate = Date.now
  @State private var endDate = Date.now

  var body: some View {
    ZStack {
      BackgroundView()

      HStack(alignment: .center) {
        VStack(alignment: .leading) {

          Text("Dashboard")
            .font(.system(size: 20, weight: .bold))
            .shadow(radius: 10)
            .padding(.top, 12)

          HStack(alignment: .center) {
            DashboardDateButton(text: viewModel.startDateString, pickDate: $viewModel.startDate)
            .padding(.trailing, 15)

            Image("rightArrow").padding(.trailing, 15)

            DashboardDateButton(text: viewModel.endDateString, pickDate: $viewModel.endDate)
          }
          .padding(.top, 36)

          ScrollView {
            // Balance
            TransactionChartView(title: "Balance",
                                 amount: viewModel.balanceTotal,
                                 transactions: viewModel.filteredTransactions)

            // Income
            TransactionChartView(title: "Income",
                                 amount: viewModel.incomeTotal,
                                 transactions: viewModel.incomeTransactions)

            // Expense
            TransactionChartView(title: "Expenses",
                                 amount: viewModel.expensesTotal,
                                 transactions: viewModel.expenseTransactions)
          }

          Spacer()
        }
        .task {
          viewModel.loadTransactions()
        }
      }
      .padding(.horizontal, 20)

      VStack(alignment: .trailing) {
        Spacer()
        HStack(alignment: .bottom) {
          Spacer()
          VStack() {
            Text("+")
              .font(.system(size: 20, weight: .bold))
              .foregroundStyle(.white)
              .frame(width: 20, height: 20)

          }
          .frame(width: 60, height: 60)
          .background(Color("AccentColor"))
          .clipShape(Circle())
        }
        .padding(.trailing, 5)
      }
      .padding(.bottom, 5)

    }
  }
}

#Preview {
  DashboardScreen()
}

struct BankingListCell: View {

  let transaction: Transaction

  var body: some View {
    HStack {
      Text(transaction.type)
        .font(.title2)
        .fontWeight(.medium)
      
      Text("$\(transaction.amount, specifier: "%.2f")")
        .foregroundColor(.secondary)
        .fontWeight(.semibold)
    }
    .padding(.leading)

  }
}

struct DashboardDateButton: View {
  var text: String
  @Binding var pickDate: Date

  var body: some View {
    DatePicker(selection: $pickDate, in: ...Date.now, displayedComponents: .date) {
    }
    .cornerRadius(8)
    .labelsHidden()
  }
}

struct BackgroundView: View {
  var topColor: Color = Color("backgroundColor")
  var bottomColor: Color = Color("backgroundColor")

  var body: some View {
    LinearGradient(gradient: Gradient(colors: [topColor, bottomColor]),
                   startPoint: .topLeading, endPoint: .bottomTrailing)
    .ignoresSafeArea()
  }
}

struct TransactionChartView: View {
  var title: String = ""
  var amount: Double = 0.0
  var transactions: [Transaction] = [Transaction]()

  var body: some View {
    VStack {
      HStack {
        Text(title)
        Spacer()
      }
      
      HStack {
        Text("\(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
        Spacer()
      }
      
      Chart(transactions, id: \.amount) { item in
        BarMark(
          x: .value("Category", item.createdAtDate),
          y: .value("Value", item.amount)
        )
      }
      .frame(height: 200)
    }
    .padding(.top, 32)
  }
}
