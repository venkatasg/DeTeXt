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
                // Appearance
//                Section(header: Text("Appearance"),
//                        content: {
//                            Picker(selection: $settings.theme, label: Text("Color Palette")) {
//                                    ForEach.init(0..<themes.count) { index in
//                                        Text(themes[index].description).tag(index)
//                                    }
//                                }
//                                .pickerStyle(SegmentedPickerStyle())
//                        })
                
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
                                        Image(systemName: "lightbulb")
                                        Text("Feedback")}) {
                    Text("You can contact me on Twitter for support, to report any bugs, or to suggest new features for the app.")
                    HStack {
                        Image(systemName: "message.fill")
                            .foregroundColor(.blue)
                        Link("Contact me on Twitter", destination: URL(string: "https://twitter.com/_venkatasg")!)
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Image(systemName: "heart.circle.fill")
                            .foregroundColor(.pink)
                        Link("Rate DeTeXt", destination: URL(string: "itms-apps://itunes.apple.com/app/id1531906207?action=write-review")!)
                            .foregroundColor(.primary)
                    }
                }
                
                // Info
                Section(header: HStack{
                            Image(systemName: "questionmark.circle")
                            Text("Info")}){
                    NavigationLink(destination: PrivacyView(), label: {
                        HStack {
                                Image(systemName: "lock.shield")
                                        .foregroundColor(.green)
                                Text("Privacy")
                        }
                    })
                    NavigationLink(destination: AboutView(), label: {
                        HStack {
                                Image(systemName: "info.circle.fill")
                                        .foregroundColor(.blue)
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
