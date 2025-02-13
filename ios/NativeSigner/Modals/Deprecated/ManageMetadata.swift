//
//  ManageMetadata.swift
//  NativeSigner
//
//  Created by Alexander Slesarev on 20.12.2021.
//

import SwiftUI

struct ManageMetadata: View {
    var content: MManageMetadata
    let navigationRequest: NavigationRequest
    @State private var removeMetadataAlert = false
    @State private var offset: CGFloat = 0
    var body: some View {
        MenuStack {
            HeaderBar(line1: Localizable.manageMetadata.key, line2: Localizable.selectAction.key).padding(.top, 10)
            MetadataCard(
                meta: MMetadataRecord(
                    specname: content.name,
                    specsVersion: content.version,
                    metaHash: content.metaHash,
                    metaIdPic: content.metaIdPic
                )
            )
            HStack {
                Localizable.usedFor.text
                VStack {
                    ForEach(content.networks.sorted(by: {
                        $0.order < $1.order
                    }), id: \.order) { network in
                        ZStack {
                            if network.currentOnScreen {
                                RoundedRectangle(cornerRadius: 4).stroke().frame(height: 30)
                            }
                            NetworkCard(title: network.title, logo: network.logo)
                        }
                    }
                    EmptyView()
                }
            }
            MenuButtonsStack {
                BigButton(
                    text: Localizable.signThisMetadata.key,
                    isShaded: true,
                    isCrypto: true,
                    action: { navigationRequest(.init(action: .signMetadata)) }
                )
                BigButton(
                    text: Localizable.deleteThisMetadata.key,
                    isShaded: true,
                    isDangerous: true,
                    action: { removeMetadataAlert = true }
                )
            }
        }
        .offset(x: 0, y: offset)
        .gesture(
            DragGesture()
                .onChanged { drag in
                    self.offset = drag.translation.height
                }
                .onEnded { drag in
                    if drag.translation.height > 40 {
                        self.offset = UIScreen.main.bounds.size.height
                        navigationRequest(.init(action: .goBack))
                    }
                }
        )
        .alert(isPresented: $removeMetadataAlert, content: {
            Alert(
                title: Localizable.removeMetadataQuestion.text,
                message: Localizable.thisMetadataWillBeRemovedForAllNetworks.text,
                primaryButton: .cancel(Localizable.cancel.text),
                secondaryButton: .destructive(
                    Localizable.removeMetadata.text,
                    action: { navigationRequest(.init(action: .removeMetadata)) }
                )
            )
        })
    }
}

// struct ManageMetadata_Previews: PreviewProvider {
// static var previews: some View {
// ManageMetadata()
// }
// }
