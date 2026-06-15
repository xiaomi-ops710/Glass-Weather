import SwiftUI

struct GlassStyle {
    // Glass Background: Semi-transparent white with blur effect
    static let glassBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.15),
                Color.white.opacity(0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Glass Border: Subtle border to enhance glass effect
    static let glassBorder: some ShapeStyle {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.6),
                Color.white.opacity(0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // Glass Modifier: Apply glass effect to any view
    static func glassEffect(cornerRadius: CGFloat = 20) -> some ViewModifier {
        GlassEffectModifier(cornerRadius: cornerRadius)
    }
}

struct GlassEffectModifier: ViewModifier {
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(24)
            .background(GlassStyle.glassBackground)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(GlassStyle.glassBorder, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func glassEffect(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassEffectModifier(cornerRadius: cornerRadius))
    }
}
