//
//  CopyToastView.swift
//  iOS
//
//  Created by Venkat & Claude on 20/10/24.
//

import SwiftUI

//Manage toast state and timing
@Observable @MainActor
class ToastManager {
    var currentToast: Toast?
    private var task: Task<Void, Never>?
    
    struct Toast: Equatable {
        let id = UUID()
        let text: String
    }
    
    func show(_ text: String, duration: Double = 2.0) {
        // Cancel any existing task
        task?.cancel()
        
        // Dismiss current toast if exists
        if currentToast != nil {
            currentToast = nil
        }
        
        // Show new toast
        showNewToast(text, duration: duration)
    }
    
    private func showNewToast(_ text: String, duration: Double) {
        withAnimation {
            currentToast = Toast(text: text)
        }
        // Suspend the toast for duration before dismissing on main thread
        task = Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                currentToast = nil
            }
        }
    }
}

struct ToastModifier: ViewModifier {
    var toastManager: ToastManager
    
    func body(content: Content) -> some View {
        ZStack (alignment: .top) {
            content
            
            if let toast = toastManager.currentToast {
                CopyToastView(whatsCopied: toast.text)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .id(toast.id)  // Force view replacement on id change
                    .padding(.vertical, 10)
            }
        }
    }
}

// View extension to make it easier to use
extension View {
    func toast(using toastManager: ToastManager) -> some View {
        modifier(ToastModifier(toastManager: toastManager))
    }
}

struct CopyToastView: View {
    
    var whatsCopied: String
    
    var body: some View {
        HStack {
            Text("Copied")
                .fontDesign(.rounded)
            Text("\(self.whatsCopied)")
                .font(.system(.body, design: .monospaced))
        }
        .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                            Capsule()
                                .fill(Color(UIColor.systemBackground))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                        )
                .shadow(color: Color.primary.opacity(0.1), radius: 3, x: 0, y: 2)
                .shadow(color: Color.primary.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    CopyToastView(whatsCopied: "command")
}
