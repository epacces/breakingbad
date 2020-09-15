import SwiftUI

public struct SearchBar: View {

    @State private var isFocused = false

    @Binding public var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public var body: some View {

        HStack {

            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
            )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isFocused = true
            }

            if isFocused {
                Button(action: {
                    self.isFocused = false
                    self.text = ""

                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}


