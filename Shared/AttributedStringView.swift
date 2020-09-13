//
//  AttributedStringView.swift
//  iOS
//
//  Created by Venkat on 12/9/20.
//

import SwiftUI


struct AboutViewNew: View {
    
//    @StateObject var viewText = AboutTextModel()
    
    var body: some View {
        GeometryReader { geometry in
            List {
                Text("Made, with ❤️, by Venkat. Inspired by Detexify, I wanted to make a native iOS app to detect LaTeX symbols that was fast, efficient, and light.")
                Section(header: Text("Feedback")) {
                    Text("hi")
                }
                Section(header: Text("How it works")) {
                    
                }
                Section(header: Text("Privacy")) {
                    
                }
                Section(header: Text("Thanks")) {
                    
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct AttributedStringView: UIViewRepresentable {
    
    let string: NSAttributedString
    let preferredMaxLayoutWidth: CGFloat
    
    func makeUIView(context: Context) -> HackedTextView {
        return HackedTextView()
    }

    func updateUIView(_ view: HackedTextView, context: Context) {
        view.attributedText = string
        
        view.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        view.isScrollEnabled = false
        view.textContainer.lineBreakMode = .byWordWrapping
        
        view.isUserInteractionEnabled = true
        view.adjustsFontForContentSizeCategory = true
        view.font = .preferredFont(forTextStyle: .body)
        view.textColor = UIColor.label
        view.backgroundColor = UIColor.secondarySystemGroupedBackground

        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
}

class HackedTextView: UITextView {
    var preferredMaxLayoutWidth = CGFloat.zero
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize(width: preferredMaxLayoutWidth, height: .infinity))
    }
}

class AboutTextModel: ObservableObject {

    var feedback: NSAttributedString
    var howitworks: NSAttributedString
    var thanks: NSAttributedString
    var privacy: NSAttributedString

    init() {
        feedback = AboutTextModel.loadResource("feedback")
        howitworks = AboutTextModel.loadResource("howitworks")
        privacy = AboutTextModel.loadResource("privacy")
        thanks = AboutTextModel.loadResource("thanks")
        
        }

    private static func loadResource(_ resource: String) -> NSAttributedString {
        let url = Bundle.main.url(forResource: resource, withExtension: "md")!
        return try! NSAttributedString(url: url, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)

        }

}

struct AboutViewNew_Previews: PreviewProvider {
    static var previews: some View {
        AboutViewNew()
            .previewDevice("iPhone 11 Pro Max")
    }
}
