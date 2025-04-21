//
//  StreaksView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//
import SwiftUI

struct StreaksView: View {
    @Binding var selectedTab: Int
    @State private var showCreateModal = false
    
    var body: some View {
        @State var emptyStreaks: Bool = true
        @State var emptyPinnedStreaks: Bool = true
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Streaks")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.bottom, 2)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image("star")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("My Streaks")
                            .font(.system(size: 18, weight: .medium))
                        
                        Spacer()
                        
                        if !emptyStreaks {
                            Button {
                                // TODO: - Create 버튼
                                self.showCreateModal = true
                            } label: {
                                Image(systemName: "note.text.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                            .padding(.trailing, 8)
                            .sheet(isPresented: self.$showCreateModal) {
                                CreateModalView()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.medium])
                            }
                        }
                    }
                    .padding([.horizontal, .vertical], 16)
                    
                    // 아직 등록된 Streak이 없는 경우
                    if emptyStreaks {
                        HStack {
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 16) {
                                Text("Ready to Start a New Streak?")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding()
                                
                                Button(action: {
                                    self.showCreateModal = true
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        
                                        Text("Create Streak")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                }
                            }
                            .sheet(isPresented: self.$showCreateModal) {
                                CreateModalView()
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.height(580)])
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            // 두번겹쳐쓰기 지린다 ㅋㅋ
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                            
                            .padding(.horizontal, 16)
                            
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    Image("pin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Pinned Other's Streaks")
                        .font(.system(size: 18, weight: .medium))
                    
                    Spacer()
                }
                .padding([.horizontal, .vertical], 16)
                
                // 아직 등록된 Pinned Streak이 없는 경우
                if emptyPinnedStreaks {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            Text("Send a Cheer to Someone!")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Button(action: {
                                // Discovery 탭으로 이동
                                selectedTab = 1
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "fireplace.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    
                                    Text("Go to Discovery")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .padding()
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
        }
    }
}


#Preview {
    StreaksView(selectedTab: .constant(0))
}
