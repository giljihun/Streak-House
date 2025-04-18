//
//  ChipsFlowView.swift
//  Streak House
//
//  Created by 길지훈 on 4/19/25.
//


import SwiftUI

struct ChipsFlowView: View {
    let items: [String]
    @Binding var selectedItems: Set<String>
    let horizontalSpacing: CGFloat = 12
    let verticalSpacing: CGFloat = 12
    
    var body: some View {
        FlowLayout(
            mode: .scrollable,
            items: items,
            itemSpacing: horizontalSpacing,
            lineSpacing: verticalSpacing
        ) { item in
            Button(action: {
                if selectedItems.contains(item) {
                    selectedItems.remove(item)
                } else {
                    selectedItems.insert(item)
                }
            }) {
                Text(item)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(selectedItems.contains(item) ? .white : .black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                        Capsule()
                            .fill(selectedItems.contains(item) ? Color.blue : Color(.systemGray6))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}
