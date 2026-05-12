import SwiftUI

// MARK: - Updates View

struct UpdatesView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Updates")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
