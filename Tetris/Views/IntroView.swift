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

                // Your existing content

                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .padding(12)
                        .foregroundStyle(.white)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .padding()
                .popover(isPresented: $showSettings) {
                    SettingsPopup(soundEnabled: $soundEnabled,fxEnabled: $fxEnabled)
                }
            }
            VStack(alignment: .center) {
                    //                Spacer()
                    Image("LogoTetroids")
                        .resizable()
                        .scaledToFit()
                        .frame(width: (proxy.size.width / 4) * 3)
                    //                Spacer()
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
//                    .onTapGesture {
//                        if manager.gameState == .intro {
//                            manager.startGame()
//                        }
//                    }
                    Spacer()
                
                }
                .onAppear {
                    print("game size \(proxy.size)")
                    manager.gameSize = proxy.size
                    manager.setInit()
                }.background(.clear)
                    .frame(maxWidth: .infinity)
            }
        
    }
    
}

struct SettingsPopup: View {
    @Binding var soundEnabled: Bool
    @Binding var fxEnabled: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Toggle("Music", isOn: $soundEnabled)
                    .foregroundStyle(.white)
                Spacer()
                Toggle("Sound FX", isOn: $fxEnabled)
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationBackground(
            LinearGradient(
                colors: [.indigo, .purple],
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
