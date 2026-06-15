import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content
    var padding: CGFloat = 24
    var cornerRadius: CGFloat = 20
    
    var body: some View {
        VStack {
            content
        }
        .padding(padding)
        .background(GlassStyle.glassBackground)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(GlassStyle.glassBorder, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    GlassCard {
        Text("Glass Card Preview")
            .foregroundColor(.white)
    }
    .padding()
    .background(LinearGradient(
        gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.2)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ))
}
