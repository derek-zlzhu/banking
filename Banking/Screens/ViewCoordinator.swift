//
//  ViewCoordinator.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import SwiftUI

struct ViewCoordinator: View {
  @State private var isActive = false
  
  var body: some View {
    if isActive {
      ContentView()
    }else {
      SplashScreen(isActive: $isActive)
    }
  }
}

#Preview {
  ViewCoordinator()
}
