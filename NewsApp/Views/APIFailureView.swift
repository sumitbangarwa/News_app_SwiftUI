//
//  APIFailureView.swift
//  NewsApp
//
//  Created by Sumit Bangarwa on 29/09/23.
//

import SwiftUI

struct APIFailureView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Try again")
            }
        }
    }
}

struct APIFailureView_Previews: PreviewProvider {
    static var previews: some View {
        APIFailureView(text: "An error ocurred") {
            
        }
    }
}
