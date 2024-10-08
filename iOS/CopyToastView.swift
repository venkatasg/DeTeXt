//
//  CopyToastView.swift
//  iOS
//
//  Created by Venkat on 19/9/23.
//

import SwiftUI

// Toast modifier to handle showing/hiding of toast
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let text: String
    let duration: Double
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    CopyToastView(whatsCopied: text)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                }
            }
        }
    }
}

// View extension to make it easier to use
extension View {
    func toast(isShowing: Binding<Bool>, text: String, duration: Double = 2.0) -> some View {
        modifier(ToastModifier(isShowing: isShowing, text: text, duration: duration))
    }
}

struct CopyToastView: View {
    
    @State var whatsCopied: String
    
    var body: some View {
        HStack {
            Text("Copied")
                .fontDesign(.rounded)
            Text("\(self.whatsCopied)")
                .font(.system(.body, design: .monospaced))
        }
        .padding()
        .background(.background)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    CopyToastView(whatsCopied: "command")
}
