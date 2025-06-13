
import SwiftUI
import PhotosUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var selectedPositionId: Int?
    @Published var isNeedShowPhotoError: Bool = false
    @Published var selectedImage: Data?
    @Published var selectedImageItem: PhotosPickerItem? {
        didSet {
            Task {
                if let data = try? await selectedImageItem?.loadTransferable(type: Data.self) {
                    selectedImage = data
                    isNeedShowPhotoError = false
                }
            }
        }
    }

    @Published var positions: [Position] = []

    @Published var showSuccess = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isLoading = false

    var isValidParams: Bool {
        !name.isEmpty && email.isValidEmail() && phone.isValidPhoneNumber()
    }
    
    func getPositions() {
        NetworkManager.getPositions { [weak self] model in
            self?.positions = model.positions
        } failure: { [weak self] error in
            self?.errorMessage = error.displayMessage
            self?.showError = true
        }
    }

    func register() async {
        guard let image = selectedImage else {
            isNeedShowPhotoError = true
            return
        }
        guard isValidParams, let selectedPositionId else { return }
        isLoading = true
        NetworkManager.registerUser(name: name, email: email, phone: phone, positionId: selectedPositionId, photo: image) { [weak self] _ in
            self?.showSuccess = true
            self?.resetForm()
            self?.isLoading = false
        } failure: { [weak self] error in
            self?.errorMessage = error.displayMessage
            self?.showError = true
            self?.isLoading = false
        }
    }

    private func resetForm() {
        name = ""
        email = ""
        phone = ""
        selectedImage = nil
        selectedImageItem = nil
    }
}
