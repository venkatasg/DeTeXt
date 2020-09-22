//
//  SettingsView.swift
//  iOS
//
//  Created by Venkat on 20/9/20.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var settings: AppSettings
    private let themes = ColorPalette.allCases
    
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
                
                //Help
                Section(header: Text("Help")) {
                    Text("You can contact me on Twitter to ask for support, report any bugs, or to suggest any features for the app. Feel free to file issues on GitHub as well!")
                    Link("My Twitter", destination: URL(string: "https://twitter.com/_venkatasg")!)
                    Link("GitHub Repository", destination: URL(string: "https://github.com/venkatasg/DeTeXt")!)
                }
                
                Section(header: Text("Privacy Policy")) {
                    Text("DeTeXt does not collect or store any personal data or information.")
                }
                
                // About
                Section(header: Text(appVersion()),
                        content: {NavigationLink(destination: AboutView(), label: {Text("About DeTeXt")})})
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
