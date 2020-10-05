//
//  CanvasView.swift
//  DeTeXt Watch Extension
//
//  Created by Venkat on 5/10/20.
//

import SwiftUI

struct CanvasView: View {
    var body: some View {
        NavigationView {
            Text("Draw here")
            
            .navigationBarTitle("Draw")
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
