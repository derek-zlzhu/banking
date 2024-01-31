//
//  SplashScreen.swift
//  Banking
//
//  Created by Derek Zhu on 2024-01-30.
//

import SwiftUI

struct SplashScreen: View {
  @Binding var isActive: Bool

  var body: some View {
    ZStack {
      BackgroundView(topColor: Color("bgTopColor"), bottomColor: Color("bgBottomColor"))

      VStack {
        VStack {
          Image("logo")
            .font(.system(size: 100))
            .foregroundColor(.blue)
        }
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        withAnimation {
          self.isActive = true
        }
      }
    }
  }
}

#Preview {
  SplashScreen(isActive: .constant(true))
}
