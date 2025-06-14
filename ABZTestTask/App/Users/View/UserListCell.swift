
import SwiftUI

struct UserListCell: View {
    var user: UserModel
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                AsyncImage(url: URL(string: user.photo)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Color.gray
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.top, 4)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                    .foregroundStyle(mainTextColor)
                Text(user.position)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(Color(hex: "#000000", opacity: 0.6))
                Text(user.email)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(mainTextColor)
                    .padding(.top, 4)
                Text(user.phone)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(14))
                    .foregroundStyle(mainTextColor)
                    .padding(.bottom, 24)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color(hex: "#000000", opacity: 0.12))
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
    }
}
