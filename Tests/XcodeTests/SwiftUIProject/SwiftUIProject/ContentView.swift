//
//  ContentView.swift
//  SwiftUIProject
//
//  Created by Akihiro Orikasa on 2022/08/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(NSLocalizedString("Hello, world!", comment: ""))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
