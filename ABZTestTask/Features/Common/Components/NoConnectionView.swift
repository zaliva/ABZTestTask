
import SwiftUI

struct NoConnectionView: View {
    var retryAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("noInternetIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text(LocalizeStrings.noInternetConnection)
                .font(FontName.regular.fontNunitoSansFontWeightSans(20))
                .multilineTextAlignment(.center)
            Button(action: retryAction) {
                Text(LocalizeStrings.tryAgain)
                    .padding(12)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .background(Color(hex: "#F4E041"))
                    .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                    .foregroundColor(.black)
                    .cornerRadius(24)
            }
            .frame(height: 48)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NoConnectionView {}
}
