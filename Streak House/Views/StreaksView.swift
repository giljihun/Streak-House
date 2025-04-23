//
//  StreaksView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//
import SwiftUI
import FirebaseAuth

struct StreaksView: View {
    @Binding var selectedTab: Int
    @State private var showCreateModal = false
    @StateObject var myViewModel = MyStreaksViewModel()
    @StateObject var pinViewModel = PinnedStreaksViewModel()
    
    var emptyStreaks: Bool { myViewModel.myStreaks.isEmpty }
    var emptyPinnedStreaks: Bool { pinViewModel.pinnedStreaks.isEmpty }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Streaks")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
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
                                    .presentationDetents([.height(580)])
                            }
                        }
                    }
                    .padding([.horizontal, .vertical], 16)
                    
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
                                .padding(.bottom, 16)
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
                    } else {
                        ForEach(myViewModel.myStreaks) { streak in
                            MyStreakCardView(streak: streak)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 12)
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
                            .padding(.bottom, 16)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                } else {
                    ForEach(pinViewModel.pinnedStreaks) { streak in
                        PinnedStreakCardView(
                            creatorName: streak.creatorName,
                            title: streak.title,
                            streakCount: streak.streakCount,
                            isCheered: streak.isCheered,
                            onUnpin: {
                                // TODO: Unpin action
                            },
                            onCheer: {
                                pinViewModel.cheer(for: streak.id)
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.9756051898, green: 0.9805480838, blue: 0.9847753644, alpha: 1)))
        }
        //.padding(.bottom, 8)
        .onAppear {
            myViewModel.fetchMyStreaks()
            if let uid = Auth.auth().currentUser?.uid {
                pinViewModel.fetchPinnedStreaks(for: uid)
            }
        }
    }
}


#Preview {
    StreaksView(selectedTab: .constant(0))
}
