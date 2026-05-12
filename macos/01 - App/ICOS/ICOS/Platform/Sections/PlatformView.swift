import SwiftUI

// MARK: - Platform View

struct PlatformView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Platform")
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
