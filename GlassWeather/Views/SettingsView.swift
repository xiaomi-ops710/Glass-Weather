import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationSettings = LocalStorageService.shared.loadNotificationSettings()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(isDaytime: true)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("設定")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("通知設定")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ToggleSetting(
                                    label: "通知を有効にする",
                                    isOn: $notificationSettings.isEnabled
                                )
                                
                                if notificationSettings.isEnabled {
                                    ToggleSetting(
                                        label: "雨の時に通知",
                                        isOn: $notificationSettings.notifyOnRain
                                    )
                                    
                                    ToggleSetting(
                                        label: "雷雨の時に通知",
                                        isOn: $notificationSettings.notifyOnStorm
                                    )
                                    
                                    ToggleSetting(
                                        label: "極寒時に通知",
                                        isOn: $notificationSettings.notifyOnExtremeCold
                                    )
                                    
                                    HStack {
                                        Text("極寒の閾値")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Stepper(
                                            value: $notificationSettings.temperatureThresholdCold,
                                            in: -50...10,
                                            step: 1
                                        )
                                        Text("\(String(format: "%.0f", notificationSettings.temperatureThresholdCold))°C")
                                            .foregroundColor(.white)
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    
                                    ToggleSetting(
                                        label: "熱中症時に通知",
                                        isOn: $notificationSettings.notifyOnExtremeHeat
                                    )
                                    
                                    HStack {
                                        Text("熱中症の閾値")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Stepper(
                                            value: $notificationSettings.temperatureThresholdHeat,
                                            in: 25...50,
                                            step: 1
                                        )
                                        Text("\(String(format: "%.0f", notificationSettings.temperatureThresholdHeat))°C")
                                            .foregroundColor(.white)
                                    }
                                    .padding(12)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("アプリについて")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("バージョン")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text("1.0.0")
                                            .foregroundColor(.white)
                                    }
                                    
                                    HStack {
                                        Text("開発者")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text("xiaomi-ops710")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onDisappear {
                LocalStorageService.shared.saveNotificationSettings(notificationSettings)
            }
        }
    }
}

struct ToggleSetting: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(.cyan)
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
}
