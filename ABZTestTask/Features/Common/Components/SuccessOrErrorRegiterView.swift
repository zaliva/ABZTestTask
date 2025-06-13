
import SwiftUI

struct SuccessOrErrorRegiterView: View {
    var message: String
    var icon: String
    var onDissmiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: onDissmiss) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .tint(Color(hex: "#000000", opacity: 0.48))
                }
            }
            Spacer()
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text(message)
                .font(FontName.regular.fontNunitoSansFontWeightSans(20))
                .multilineTextAlignment(.center)
            Button(action: onDissmiss) {
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
    SuccessOrErrorRegiterView(message: LocalizeStrings.emailAlreadyRegistered, icon: "errorRegisterIcon") {}
}
