
import SwiftUI

struct HeaderBannerView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(FontName.regular.fontNunitoSansFontWeightSans(20))
            .foregroundColor(Color(hex: "#1D1B20"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#F4E041"))
    }
}

#Preview {
    HeaderBannerView(title: LocalizeStrings.headerGetMsg)
}
