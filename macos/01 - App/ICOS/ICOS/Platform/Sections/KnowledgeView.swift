import SwiftUI

// MARK: - Knowledge View

struct KnowledgeView: View {

    var body: some View {
        VStack(spacing: 0) {

            Text("Knowledge & Research")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}