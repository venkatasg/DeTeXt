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
//                SearchBar(text: $searchText)
//                    .padding(.top, 8)
//                    .padding(.bottom, 8)
                
                NavigationLink(
                    destination: ContentView(pack: "tipa")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("tipa")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("TIPA symbols"))
                            
                        }
                    }
                )
                
                NavigationLink(
                    destination: ContentView(pack: "amsmath")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("amsmath")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("AMSMATH symbols"))
                            
                        }
                    }
                )
                
                NavigationLink(
                    destination: ContentView(pack: "amssymb")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("amssymb")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("AMSSYMB symbols"))
                            
                        }
                    }
                )
            }
            .navigationBarTitle("Browse")
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
