//
//  Keyboard.swift
//  Streak House
//
//  Created by 길지훈 on 4/22/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
