//
//  AboutView.swift
//  iOS
//
//  Created by Venkat on 20/9/20.
//

import SwiftUI

struct AboutView: View {
        
    var body: some View {
        NavigationView {
            List {
                Section(header: Text(appVersion()).padding(.leading, 20)) {
                    Text("Made, with ❤️, by Venkat. Inspired by Detexify, I wanted to make a native iOS app for translating hand-drawn symbols to their corresponding LaTeX commands that was fast, efficient, and lightweight.")
                }
                
                //Feedback
                Section(header:Text("Feedback").padding(.leading, 20) ) {
                    Text("You can email me or contact me on Twitter for support, to report any bugs, or to suggest new features for the app.")
                    HStack {
                        Image(systemName: "envelope.fill")
                            .font(.body)
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20, alignment: .center)
                            .foregroundColor(.blue)
                            .accessibility(label: Text("Contact me on Twitter"))
                        Link("Send me an email", destination: URL(string: "mailto:venkat@venkatasg.net")!)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "quote.bubble.fill")
                            .font(.body)
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20, alignment: .center)
                            .foregroundColor(.blue)
                            .accessibility(label: Text("Contact me on Twitter"))
                        Link("Contact me on Twitter", destination: URL(string: "https://twitter.com/_venkatasg")!)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "heart.circle.fill")
                            .font(.body)
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20, alignment: .center)
                            .foregroundColor(.pink)
                            .accessibility(label: Text("Please Rate & Review DeTeXt"))
                        Link("Please Rate & Review DeTeXt", destination: URL(string: "itms-apps://itunes.apple.com/app/id1531906207?action=write-review")!)
                            .foregroundColor(.primary)
                    }
                }
                
                // Info
                InfoView()
                
                // Credits
                Section(header: Text("Credits").padding(.leading, 20)) {
                    Text("Thanks to Daniel Kirsch and the team at Detexify for their cool open-source web app that inspired me to make DeTeXt, and for providing the training data and prompt responses to my questions. \n\nThanks to Will Bishop for helping me figure out a tricky problem I had with the PencilKit APIs.\n\nA big thanks to Hans for beta testing new features and giving valuable feedback. \n\nFinally a big thanks to all the folks on the NetNewsWire Slack for being supportive and inspiring me to build my own iOS app.")
                    Link("Will Bishop", destination: URL(string: "https://willbish.com")!)
                    Link("Hans", destination: URL(string: "https://twitter.com/SherlockHans")!)
                    Link("NetNewsWire", destination: URL(string: "https://ranchero.com/netnewswire/")!)
                }
                
                //Privacy
                Section(header: Text("Privacy").padding(.leading, 20)) {
                        Text("DeTeXt does not collect or store any personal data or information. All processing of drawings to find the corresponding symbol happens on your device.")
                    Text("DeTeXt does not display any advertisements, use any trackers or analytics, or send any data to any server.").padding(.bottom, 5)
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationTitle("About")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct AboutView_Previews: PreviewProvider {
    
    static var previews: some View {
        AboutView()
    }
}
