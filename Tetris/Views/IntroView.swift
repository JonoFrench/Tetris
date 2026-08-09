//
//  IntroView.swift
//  Tetris
//
//  Created by Jonathan French on 30.11.25.
//


import SwiftUI
import Combine

struct IntroView: View {
    static var starttextSize:CGFloat = 28
    static var helptextSize:CGFloat = 17
    @EnvironmentObject var manager: GameManager
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("fxEnabled") private var fxEnabled = true
    @AppStorage("thumpEnabled") private var thumpEnabled = true
    @State private var showSettings = false
    private let numberOfViews = 1
    private let pages:[AnyView] = [
        AnyView(Intro1View()),
        AnyView(Intro2View()),
        AnyView(Intro3View())
    ]
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .center) {
                    Image("LogoTetroids")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (proxy.size.width / 4) * 3)
                    SmoothCarousel(pages: [
                        AnyView(Intro1View()),
                        AnyView(Intro2View()),
                        AnyView(Intro3View())
                    ])
                    Spacer()
                    PlayButton(btnTxt: "TAP TO PLAY") {
                        if manager.gameState == .intro {
                            manager.startGame()
                        }
                    }
                    Spacer()
                    
                }
                .onAppear {
                    print("game size \(proxy.size)")
                    manager.gameSize = proxy.size
                    manager.setInit()
                }.background(.clear)
                    .frame(maxWidth: .infinity)
                
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
//                        .padding(12)
                        .foregroundStyle(.white)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
                .popover(isPresented: $showSettings) {
                    SettingsPopup(soundEnabled: $soundEnabled,fxEnabled: $fxEnabled,thumpEnabled: $thumpEnabled)
                }
            }
        }

    }
}

struct SettingsPopup: View {
    @Binding var soundEnabled: Bool
    @Binding var fxEnabled: Bool
    @Binding var thumpEnabled: Bool
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var manager: GameManager

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Toggle("Music", isOn: $soundEnabled)
                    .foregroundStyle(.white)
                Spacer()
                Toggle("Sound FX", isOn: $fxEnabled)
                    .foregroundStyle(.white)
                Spacer()
                Toggle("Tactile", isOn: $thumpEnabled)
                    .foregroundStyle(.white)

//                Button("Done") {
//                    dismiss()
//                }
//                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .frame(width: 260, height: 260)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemIndigo))
            )
//            .navigationTitle("Settings")
            .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti).bold())
            .foregroundStyle(manager.gradOtoY)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.custom("HelveticaNeue", size: IntroView.starttextSize * manager.deviceMulti).bold())
                        .foregroundStyle(manager.grad)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                }
            }
        }
        .presentationBackground(
            LinearGradient(
                colors: [.black, .blue],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct SettingsPopup2: View {
    @Binding var soundEnabled: Bool
    @Binding var fxEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("Settings")
                .font(.headline)

            Toggle("Music", isOn: $soundEnabled)
            Toggle("Sound FX", isOn: $fxEnabled)

        }
        .padding()
        .frame(width: 220)
    }
}
