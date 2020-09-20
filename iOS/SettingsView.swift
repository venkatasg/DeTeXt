//
//  SettingsView.swift
//  iOS
//
//  Created by Venkat on 20/9/20.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var clearOnTap = false
    @State private var theme = 0
    let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    var body: some View {
        NavigationView {
            List {
                
                // Appearance
                Section(header: Text("Appearance"),
                        content: {
                                    Picker(selection: $theme, label: Text("Color Palette")) {
                                        Text("System").tag(0)
                                        Text("Light").tag(1)
                                        Text("Dark").tag(2)
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                        })
                
                
                Section(header: Text("Apple Pencil"),
                        footer: Text("Available only on 2nd generation Apple Pencil"),
                        content: {
                                 Toggle("Double tap Apple Pencil to clear canvas", isOn: $clearOnTap)
                                })
                
                Section(header: Text("DeTeXt \(appVersionString)"),
                        content: {NavigationLink(destination: AboutView(), label: {Text("About DeTeXt")})})
            }
            .listStyle(InsetGroupedListStyle())
            
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            
    }
}
