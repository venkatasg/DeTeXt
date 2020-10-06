//
//  BrowseView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 6/10/20.
//

import SwiftUI

struct BrowseView: View {
    
    @EnvironmentObject var symbols: Symbols
    
    var body: some View {
        NavigationView {
            List {
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
                
                NavigationLink(
                    destination: ContentView(pack: "upgreek")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("upgreek")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("UPGREEK symbols"))
                            
                        }
                    }
                )
                
                NavigationLink(
                    destination: ContentView(pack: "marvosym")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("marvosym")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("MARVOSYM symbols"))
                            
                        }
                    }
                )
                
                NavigationLink(
                    destination: ContentView(pack: "wasysym")
                                    .environmentObject(symbols),
                    label: {
                        HStack {
                            Text("wasysym")
                            Spacer()
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.body)
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, alignment: .center)
                                .foregroundColor(.blue)
                                .accessibility(label: Text("WASYSYM symbols"))
                            
                        }
                    }
                )
            }
            .navigationBarTitle("Browse")
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
            .environmentObject(Symbols())
    }
}
