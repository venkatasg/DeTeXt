//
//  SearchView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 5/10/20.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        NavigationView {
            VStack {
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Symbols())
    }
}
