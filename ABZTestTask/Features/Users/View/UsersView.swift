import SwiftUI

struct UsersView: View {
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderBannerView(title: LocalizeStrings.headerGetMsg)
                    .padding(.top, 1)
                if viewModel.users.isEmpty {
                    VStack(spacing: 24) {
                        Image("noUserIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text(LocalizeStrings.notYetUserText)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(20))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .alignmentGuide(.top) { _ in 0 }
                } else {
                    List(viewModel.users) { user in
                        UserListCell(user: user)
                            .onAppear() {
                                if user == viewModel.users.last {
                                    viewModel.fetchNextUsers()
                                }
                            }
                    }
                    .refreshable {
                        viewModel.fetchUsers()
                    }
                    .listStyle(.plain)
                    if viewModel.isLoadingNextPage {
                        HStack {
                            Spacer()
                            ProgressView()
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding(.vertical, 30)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .onAppear() {
            viewModel.fetchUsers()
        }
    }
}

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

#Preview {
    UsersView(viewModel: UsersViewModel())
}
