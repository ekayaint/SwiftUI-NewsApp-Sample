//
//  CustomTabView.swift
//  SwiftUI-NewsApp-Sample
//
//  Created by ekayaint on 22.10.2023.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var tabSelection: Int
    @Namespace private var AnimationNameSpace
    
    let tabBarItems: [(image: String, title: String)] = [("newspaper.fill", "News"), ("magnifyingglass", "Search"), ("gear", "Settings")]
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 80)
                .foregroundStyle(Color(.secondarySystemBackground))
                .shadow(radius: 2)
            
            HStack{
                ForEach(0..<3) { index in
                    Button {
                        tabSelection = index + 1
                    } label: {
                        VStack(spacing: 8, content: {
                            Spacer()
                            Image(systemName: tabBarItems[index].image)
                            Text(tabBarItems[index].title)
                                .font(.caption)
                            if index + 1 == tabSelection {
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundStyle(Color.blue)
                                    .matchedGeometryEffect(id: "SelectedTabID", in: AnimationNameSpace)
                                    .offset(y: 3)
                            } else {
                                Capsule()
                                    .frame(height: 8)
                                    .foregroundStyle(Color.clear)
                                    .offset(y: 3)
                            }
                            
                            
                        }) //: VStack
                        .foregroundStyle(index + 1 == tabSelection ? Color.blue : Color.gray)
                    } //: Button
                } //: for
            } //: HStack
            .frame(height: 80)
            .clipShape(Capsule())
            
        } //: ZStack
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(1))
}
