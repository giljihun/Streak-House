//
//  ChipsContainerView.swift
//  Streak House
//
//  Created by 길지훈 on 4/19/25.
//
// MARK: - NOTE
// 여러 개의 “칩(Chip)“들을 그리드처럼 자동으로 정렬해서 보여주는 뷰가 필요.
// 보통 ChipView라고 부른다고함.
// SwiftUI의 기본 LazyVGrid나 HStack은 칩처럼 동적으로 줄바꿈되는 레이아웃을 지원하지 않음

// <대충 정리한 플로우>
// 뷰 그리기 시작
//   ↓
// FlexibleChipsLayout로 넘어감
//   ↓
// generateContent(in:)에서 위치 계산
//   ↓
// ForEach로 하나씩 → content(item)
//   ↓
// content는 결국 Button(action:) 생성
//   ↓
// 사용자가 칩 클릭하면 → 선택 토글

import SwiftUI

struct ChipsContainerView: View {
    
    @Binding var selectedItems: Set<String>
    
    let items: [String]
    let verticalSpacing: CGFloat
    let horizontalSpacing: CGFloat
    
    init(items: [String], selectedItems: Binding<Set<String>>, verticalSpacing: CGFloat = 8, horizontalSpacing: CGFloat = 8) {
        self.items = items
        self._selectedItems = selectedItems
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
    }
    
    var body: some View {
        FlexibleChipsLayout(
            data: items,
            spacing: horizontalSpacing,
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
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(selectedItems.contains(item) ? .white : Color(#colorLiteral(red: 0.2157522142, green: 0.2561281919, blue: 0.3192634284, alpha: 1)))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(selectedItems.contains(item) ? Color.blue : Color(.systemGray6))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}

struct FlexibleChipsLayout<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let lineSpacing: CGFloat
    let content: (Data.Element) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        // 가로 한 줄에 들어갈 수 있는 만큼 넣고, 부족하면 줄 바꿈
        // 줄 바뀔 때마다 height 업데이트해서 아래로 배치
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        let arrayData = Array(data)
        
        return ZStack(alignment: .topLeading) {
            ForEach(arrayData, id: \.self) { item in
                content(item)
                    .padding(.trailing, spacing)
                    .padding(.bottom, lineSpacing)
                
                // 줄마다 가로 폭 초과 여부 계산해서 줄바꿈
                // 각 요소 위치를 수동으로 계산해서 배치하는 구조
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height + lineSpacing
                        }
                        let result = width
                        if item == arrayData.last {
                            width = 0
                        } else {
                            width -= d.width + spacing
                        }
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == arrayData.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
    }
}
