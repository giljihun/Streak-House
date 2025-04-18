//
//  ChipsContainerView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//
import SwiftUI

struct ChipsContainerView: View {
    let items: [String]
    @Binding var selectedItems: Set<String>
    
    // Wrapping layout
    var body: some View {
        FlexibleView(
            data: items,
            spacing: 12,
            alignment: .leading
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

// FlexibleView는 태그/칩이 한 줄에 다 안 들어가면 자동 줄바꿈 해주는 커스텀 뷰입니다.
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .leading, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        var width = CGFloat.zero
        var rows: [[Data.Element]] = [[]]
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(minHeight: 0)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var rows: [[Data.Element]] = [[]]
        for item in data {
            let itemSize = content(item)
                .fixedSize()
                .background(GeometryReader { geo in
                    Color.clear.preference(key: SizePreferenceKey.self, value: geo.size)
                })
            let itemWidth = itemSize.sizeThatFits(.zero).width
            if width + itemWidth + spacing > geometry.size.width {
                rows.append([item])
                width = itemWidth + spacing
            } else {
                rows[rows.count - 1].append(item)
                width += itemWidth + spacing
            }
        }
        return VStack(alignment: alignment, spacing: spacing) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
