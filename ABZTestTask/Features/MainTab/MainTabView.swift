
import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    @StateObject var usersViewModel = UsersViewModel()
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
                Group {
                    if selectedIndex == 0 {
                        UsersView(viewModel: usersViewModel)
                    } else {
                        SignUpView(onSuccess: {
                            usersViewModel.fetchUsers()
                        })
                    }
                }
                .padding(.bottom, keyboardHeight > 0 ? keyboardHeight - (UIApplication.shared.connectedScenes
                    .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                    .first?.safeAreaInsets.bottom ?? 0) : 64)
            HStack {
                TabBarItem(
                    icon: "person.3.fill",
                    title: LocalizeStrings.usersTab,
                    isSelected: selectedIndex == 0
                ) {
                    selectedIndex = 0
                }

                TabBarItem(
                    icon: "person.crop.circle.badge.plus",
                    title: LocalizeStrings.signUpTab,
                    isSelected: selectedIndex == 1
                ) {
                    selectedIndex = 1
                }
            }
            .frame(height: 64)
            .padding(.horizontal, 16)
            .background(Color(hex: "#F8F8F8"))
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = frame.height
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardHeight = 0
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(isSelected ? Color(hex: "#00BDD3") : Color(hex: "#000000", opacity: 0.6))
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}
