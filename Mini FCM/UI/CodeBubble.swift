//
//  CodeBubble.swift
//  Mini FCM
//
//  Created by fridakitten on 05.12.24.
//

import SwiftUI

struct CodeBubble: View {
    let title: String
    let titleColor: Color
    let bubbleColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundColor(bubbleColor)
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(titleColor)
        }
    }
}
