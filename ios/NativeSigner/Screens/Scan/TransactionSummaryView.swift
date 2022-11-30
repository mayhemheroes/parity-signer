//
//  TransactionSummaryView.swift
//  NativeSigner
//
//  Created by Krzysztof Rodak on 21/11/2022.
//

import SwiftUI

struct TransactionSummaryView: View {
    var renderable: TransactionPreviewRenderable
    let onTransactionDetailsTap: () -> Void
    @State var isShowingFullAddress: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Localizable.TransactionSign.Label.details.text
                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                    .font(Fontstyle.captionM.base)
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(renderable.summary.asRenderable, id: \.id) { row in
                            HStack(spacing: Spacing.extraSmall) {
                                Text(row.key)
                                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                                Text(row.value)
                                    .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            }
                            .font(Fontstyle.captionM.base)
                        }
                    }
                    Spacer()
                    Asset.chevronRight.swiftUIImage
                        .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                        .padding(Spacing.extraSmall)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { onTransactionDetailsTap() }
            signature()
        }
        .padding(Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Asset.fill6.swiftUIColor)
        )
    }

    @ViewBuilder
    func signature() -> some View {
        if let signature = renderable.signature {
            Divider()
            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Localizable.TransactionSign.Label.sign.text
                    .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                    .font(Fontstyle.captionM.base)
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.extraExtraSmall) {
                        Text(signature.path)
                            .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                            .font(Fontstyle.captionM.base)
                        Text(signature.name)
                            .foregroundColor(Asset.textAndIconsPrimary.swiftUIColor)
                            .font(Fontstyle.bodyM.base)
                        HStack {
                            Text(
                                isShowingFullAddress ? signature.base58 : signature.base58
                                    .truncateMiddle()
                            )
                            .foregroundColor(Asset.textAndIconsTertiary.swiftUIColor)
                            .font(Fontstyle.bodyM.base)

                            if !isShowingFullAddress {
                                Asset.chevronDown.swiftUIImage
                                    .foregroundColor(Asset.textAndIconsSecondary.swiftUIColor)
                                    .padding(.leading, Spacing.extraExtraSmall)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                isShowingFullAddress = true
                            }
                        }
                    }
                    Spacer()
                    Identicon(identicon: signature.identicon, rowHeight: Heights.identiconInCell)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct TransactionSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionSummaryView(
            renderable: .init(
                summary: PreviewData.transactionSummary,
                signature: PreviewData.transactionSignature
            ),
            onTransactionDetailsTap: {}
        )
        .preferredColorScheme(.dark)
    }
}
