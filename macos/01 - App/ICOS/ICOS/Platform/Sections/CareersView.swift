import SwiftUI

// MARK: - Careers View

struct CareersView: View {

    var body: some View {
        VStack(spacing: 0) {

            Text("Careers")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
