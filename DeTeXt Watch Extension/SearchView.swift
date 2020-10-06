//
//  SearchView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 5/10/20.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText = ""
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        NavigationView {
            List {
                TextField("Search", text: $searchText)
                
            }
            .navigationBarTitle("Search")
        }
    }
}

//struct SearchBar: View {
//
//    @Binding var text: String
//    @State private var isEditing = false
//
//    var body: some View {
//        HStack {
//            TextField("Search", text: $text)
//                .overlay(
//                    HStack {
//                        if isEditing {
//                            Button(action: {
//                                self.text = ""
//                            }) {
//                                Image(systemName: "multiply.circle.fill")
//                                    .foregroundColor(.gray)
//                                    .padding(.trailing, 8)
//                            }
//                        }
//                    }
//                )
////                .padding(.horizontal, 10)
//                .onTapGesture {
//                    self.isEditing = true
//                }
//        }
//    }
//}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Symbols())
    }
}
