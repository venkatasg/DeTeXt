//
//  SettingsView.swift
//  iOS
//
//  Created by Venkat on 20/9/20.
//

import SwiftUI

struct SettingsView: View {
    
//    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        NavigationView {
            List {
                
                // Apple Pencil
//                Section(header: Text("Apple Pencil"),
//                        footer: Text("Available only on 2nd generation Apple Pencil"),
//                        content: {
//                            Toggle("Double tap Apple Pencil to clear canvas", isOn: $settings.pencilClearOnTap)
//                                })
//                // Haptics
//                if settings.supportsHaptics {
//                    Section(header: Text("Haptics"),
//                            footer: Text("Use fewer subtle vibrations with common actions"),
//                            content: {
//                                Toggle("Reduce Haptics", isOn: $settings.reduceHaptics)
//                                    })
//                }
                
                //Feedback
                Section(header: HStack{
                                        Image(systemName: "bubble.left.and.bubble.right")
                                            .accessibility(label: Text("Feedback Section"))
                                        Text("Feedback")}) {
                    Text("You can contact me on Twitter for support, to report any bugs, or to suggest new features for the app.")
                    HStack {
                        Image(systemName: "message.fill")
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
                Section(header: HStack{
                            Image(systemName: "questionmark.circle")
                                .accessibility(label: Text("Information Section"))
                            Text("Info")}){
                    NavigationLink(destination: PrivacyView(), label: {
                        HStack {
                                Image(systemName: "lock.shield")
                                    .font(.body)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:20, alignment: .center)
                                    .foregroundColor(.green)
                                    .accessibility(label: Text("Privacy"))
                                Text("Privacy")
                        }
                    })
                    NavigationLink(destination: TipsView(), label: {
                        HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.body)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:20, alignment: .center)
                                    .foregroundColor(.yellow)
                                    .accessibility(label: Text("Tips"))
                                Text("Tips")
                        }
                    })
                    NavigationLink(destination: AboutView(), label: {
                        HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.body)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:20, alignment: .center)
                                    .foregroundColor(.blue)
                                    .accessibility(label: Text("About DeTeXt"))
                                Text("About DeTeXt")
                        }
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationBarTitle("About", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PrivacyView: View {
    
    var body: some View {
        List {
            Text("DeTeXt does not collect or store any personal data or information. All processing of drawings to find the corresponding symbol happens on your device.")
            Text("DeTeXt does not display any advertisements, use any trackers or analytics, or send any data to any server.")
        }
        .listStyle(InsetGroupedListStyle())
        
        .navigationBarTitle("Privacy", displayMode: .inline)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var settings: AppSettings = AppSettings()
    
    static var previews: some View {
        SettingsView()
            .previewDevice("iPhone 11 Pro Max")
            .environmentObject(settings)
            
    }
}
