import SwiftUI

struct WordsToFit: View {
    let text: String

    private struct SizePreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
        }
    }

    @State private var wordHeight: CGFloat = 100

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(text.split(separator: " ").map(String.init), id: \.self) { (word: String) in
                Text(word)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .background(GeometryReader {
                        Color.clear.preference(key: SizePreferenceKey.self, value: $0.size.height)
                    })
                    .frame(maxHeight: wordHeight)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: { wordHeight = $0 })
    }
}
