//
//  TipsView.swift
//  iOS
//
//  Created by Venkat on 28/9/20.
//

import SwiftUI

struct TipsView: View {
    
    var body: some View {
            List {
                
                Section(header: HStack {
                                    Image(systemName: "doc.on.doc")
                                        .accessibility(label: Text("How to copy commands"))
                                    Text("Copy commands")
                                    })
                {
                    Text("You can copy commands to the system clipboard by long-pressing on a command from the list and tapping 'Copy Command' from the context menu.")
                }
                
                Section(header: HStack {
                                    Image(systemName: "magnifyingglass")
                                        .accessibility(label: Text("Search by package"))
                                    Text("Search by Package")
                                    })
                {
                    Text("In the search tab, you can search by command name or package name. Searching by package name will show all symbols from that package.")
                }
                
                Section(header: HStack {
                                    Image(systemName: "pencil")
                                        .accessibility(label: Text("Double tap to clear with Apple Pencil"))
                                    Text("Clear with Apple Pencil")
                                    })
                {
                    Text("You can double tap your Apple Pencil (2nd generation) to quickly clear the drawing canvas and start over.")
                }
                
                
            }
            .listStyle(InsetGroupedListStyle())
    
        .navigationBarTitle("Tips", displayMode: .inline)
    }
}


struct Tips_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}

