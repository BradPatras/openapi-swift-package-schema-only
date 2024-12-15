//
//  ContentView.swift
//  OpenApiExpirementApp
//
//  Created by Brad Patras on 12/15/24.
//

import OpenAPISwiftPackageSchemaOnly
import SwiftUI

struct ContentView: View {
	@State var message: String?
	let client: Client?

    var body: some View {
        VStack {
			if let message {
				Text(message)
			}

			Button {

			} label: {
				Text("Fetch message")
			}
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
