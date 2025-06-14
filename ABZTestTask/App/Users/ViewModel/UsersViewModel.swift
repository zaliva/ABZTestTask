
import Foundation
import Combine

@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    
    var page = 0

    func fetchUsers() {
        guard !isLoading else { return }
        isLoading = true
        page = 1
        getUser(isRefresh: true)
    }
    
    func fetchNextUsers() {
        guard !isLoading else { return }
        isLoading = true
        isLoadingNextPage = true
        page += 1
        getUser(isRefresh: false)
    }
    
    func getUser(isRefresh: Bool) {
        NetworkManager.getUsers(page: page, count: 10) { model in
            if isRefresh {
                self.users = model.users
            } else {
                self.users.append(contentsOf: model.users)
            }
            self.isLoading = false
            self.isLoadingNextPage = false
        } failure: { error in
            self.isLoading = false
            self.isLoadingNextPage = false
        }
    }
}
