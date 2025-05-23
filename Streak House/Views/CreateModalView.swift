//
//  CreateStreakView.swift
//  Streak House
//
//  Created by 길지훈 on 4/21/25.
//
import SwiftUI
import Combine

struct CreateModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = CreateStreakViewModel()
    
    // MARK: - State
    @State private var goalText: String = ""
    @State private var selectedAlarmTime: Date = Date()
    @State private var hourInput: String = "0"
    @State private var minuteInput: String = "30"
    @State private var isAlarmEnabled: Bool = false
    
    // MARK: - Icon 매핑
    var categoryIconName: String {
        switch viewModel.selectedCategory {
        case "Study": return "book.fill"
        case "Health": return "figure.run"
        case "Creativity": return "paintbrush.fill"
        case "Fun": return "gamecontroller.fill"
        default: return "sparkles"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // MARK: - 상단 닫기 버튼
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                    .padding(.leading)
                    Spacer()
                }
                .padding([.top, .bottom], 10)
                
                // MARK: - 카테고리 피커
                Picker("Category", selection: $viewModel.selectedCategory) {
                    Text("Study").tag("Study")
                    Text("Health").tag("Health")
                    Text("Creativity").tag("Creativity")
                    Text("Fun").tag("Fun")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // MARK: - 카드
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: - 아이콘 색상 선택
                    let iconColors: [Color] = [
                        .red, .blue, .green, .orange, .purple,
                    ]
                    
                    let gridItems = Array(repeating: GridItem(.flexible(minimum: 44), spacing: 8), count: 5)
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        ForEach(iconColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(Circle().stroke(viewModel.iconColor == color ? Color.black : Color.clear, lineWidth: 2))
                                .onTapGesture {
                                    viewModel.iconColor = color
                                }
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.categoryIconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                            .foregroundColor(viewModel.iconColor)

                        TextField("Typing your GOAL", text: $viewModel.goalText)
                            .padding(10)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 16)
                    
                    // MARK: - 시간 입력
                    Text("🕒 How long in One day?")
                    DatePicker("🕒 How long in one day?", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .scaleEffect(0.85)
                        .frame(height: 120)
                        .clipped()
                        .padding(.bottom, 16)
                        .environment(\.locale, Locale(identifier: "en_GB"))
                    
                    // MARK: - 알람 시간 설정
                    DatePicker("⏰ Alarm Time", selection: $viewModel.selectedAlarmTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
                
                // MARK: - 생성 버튼
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.saveStreak { success in
                            if success {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                // 에러 처리 로직 추가 가능
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .padding(.trailing, 8)
                .padding(.bottom, 16)
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .background(Color(.systemGray6)
        .ignoresSafeArea())
    }
}

#Preview {
    CreateModalView()
}
