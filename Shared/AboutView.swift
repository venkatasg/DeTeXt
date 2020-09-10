//
//  About.swift
//  deTeX
//
//  Created by Venkat on 26/8/20.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 6) {
                    Text("Made, with ❤️, by Venkat. Inspired by Detexify, I wanted to make a native iOS app to detect LaTeX symbols that was fast, efficient, and light.")
                    Text("\nfeedback").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                    Text("You can contact me on Twitter @_venkatasg to report any bugs or if you have any feature requests for the app")
                    Link("My Twitter", destination: URL(string: "https://twitter.com/_venkatasg")!)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                    Text("\nhow it works").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                    Text("DeTeXt uses a MobileNet_v2 model PyTorch model trained on the DeTeXify training data, which was then translated to CoreML using ") +
                    Text("coremltools").font(.system(.body, design: .monospaced)) +
                    Text(".")
                    Text("\nthanks").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                    Text("Thanks to Daniel Kirsch and the team at Detexifier for their cool open-source web project that inspired me to make this app, and for providing the training data and prompt responses to my questions. \nThanks to Will Bishop for helping me figure out a tricky problem I had with the PencilKit APIs. \nFinally a big thanks to all the folks on the NetNewsWire Slack for being supportive and inspiring me to build my own iOS app.")
                    Text("\nlinks").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                    Link("DeTeXify", destination: URL(string: "http://detexify.kirelabs.org")!)
                    Link("coremltools", destination: URL(string: "https://coremltools.readme.io")!)
                    Link("MobileNet_v2", destination: URL(string: "https://pytorch.org/docs/stable/torchvision/models.html#torchvision.models.mobilenet_v2")!)
                    }
                }
                .padding(16)
            }
            .navigationBarTitle("About", displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.presentationMode.wrappedValue.dismiss()})                                         { Text("Back").padding(8) })
        }
    }
}


struct About_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
