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
            GeometryReader { geometry in
                List {
                    Text("Made, with ❤️, by Venkat. Inspired by Detexify, I wanted to make a native iOS app to detect LaTeX symbols that was fast, efficient, and light.")
                    Section(header: Text("Feedback")) {
                        Text("You can contact me on Twitter @_venkatasg to report any bugs or if you have any feature requests for the app")
                    }
                    Section(header: Text("How it works")) {
                        Text("DeTeXt uses a MobileNet_v2 model PyTorch model trained on the DeTeXify training data, which was then translated to CoreML using ") +
                        Text("coremltools").font(.system(.body, design: .monospaced)) +
                        Text(".")
                    }
                    
                    Section(header: Text("Privacy")) {
                        Text("DeTeXt does not collect any personal information (or does it) - whatever the default privacy policy should be of not asking for any information")
                    }
                    Section(header: Text("Thanks")) {
                        Text("Thanks to Daniel Kirsch and the team at Detexifier for their cool open-source web project that inspired me to make this app, and for providing the training data and prompt responses to my questions. \n\nThanks to Will Bishop for helping me figure out a tricky problem I had with the PencilKit APIs. \n\nFinally a big thanks to all the folks on the NetNewsWire Slack for being supportive and inspiring me to build my own iOS app.")
                    }
                    
                    Section(header: Text("Links")) {
                        Link("My Twitter", destination: URL(string: "https://twitter.com/_venkatasg")!)
                        Link("DeTeXify", destination: URL(string: "http://detexify.kirelabs.org")!)
                        Link("coremltools", destination: URL(string: "https://coremltools.readme.io")!)
                        Link("MobileNet_v2", destination: URL(string: "https://pytorch.org/docs/stable/torchvision/models.html#torchvision.models.mobilenet_v2")!)
                    }
                    
                }
                .listStyle(InsetGroupedListStyle())
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
