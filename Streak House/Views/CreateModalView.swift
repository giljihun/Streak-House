//
//  CreateStreakView.swift
//  Streak House
//
//  Created by 길지훈 on 4/21/25.
//

import SwiftUI

struct CreateModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            HStack {
                
                Spacer()
                
                // Dismiss Btn
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width:30, height: 30)
                        .foregroundStyle(Color(#colorLiteral(red: 0.8235295415, green: 0.8235294223, blue: 0.8235294223, alpha: 1)))
                    
                }
                .padding(.top, 14)
                .padding(.trailing, 16)
            }
            
            // Picker
            Picker("Category", selection: .constant("Growth")) {
                Text("Study").tag("Growth")
                Text("Health").tag("Wellness")
                Text("Creativity").tag("Creative")
                Text("Fun").tag("Leisure")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 25)
            .padding(.bottom, 12)
            
            // 구분선
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(#colorLiteral(red: 0.7803922296, green: 0.7803922296, blue: 0.7803922296, alpha: 1)))
                .padding(.horizontal)
                .padding(.bottom, 12)
            
            // cardView
            VStack() {
                Text("Ready to Start a New Streak? 🔥")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "icon")
                }

            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.bottom, 12)
            .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 2)
            .shadow(color: Color.black.opacity(0.01), radius: 0.1, x: 0, y: 1)
            
            // 생성 btn
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.forward.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                .padding(.trailing, 16)
            }
            
            Spacer()
        }
        .background(Color(#colorLiteral(red: 0.9490196109, green: 0.9490196109, blue: 0.9490196109, alpha: 1)))
    }
}

#Preview {
    CreateModalView()
}
