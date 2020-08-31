//
//  About.swift
//  deTeX
//
//  Created by Venkat on 26/8/20.
//

import SwiftUI

struct AboutView: View {
//    @Binding var showingAboutView:Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 6) {
                Text("credits").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                Text("Made, with ❤️, by Venkat. Inspired by Detexify, I wanted to make a native iOS app to detect LaTeX symbols that was fast, efficient, and light.\n\nDeTeXt uses a MobileNet_v2 model PyTorch model trained on the DeTeXify training data, which was then translated to CoreML using ") +
                Text("coremltools").font(.system(.body, design: .monospaced)) +
                Text(".")
                Text("links").font(Font.system(size: 20, design: .rounded).smallCaps()).foregroundColor(Color.gray)
                Link("DeTeXify", destination: URL(string: "http://detexify.kirelabs.org")!)
                Link("coremltools", destination: URL(string: "https://coremltools.readme.io")!)
                Link("MobileNet_v2", destination: URL(string: "https://pytorch.org/docs/stable/torchvision/models.html#torchvision.models.mobilenet_v2")!)
            }.padding(16)
            .navigationBarTitle("About", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                }) {
                HStack{
                    Image(systemName: "chevron.down")
                    Text("Back")
                }.padding(8)
            })
        }
    }
}

//
//struct About_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutView(showingAboutView: true)
//    }
//}
