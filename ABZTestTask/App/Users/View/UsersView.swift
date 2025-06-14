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

#Preview {
    UsersView(viewModel: UsersViewModel())
}
