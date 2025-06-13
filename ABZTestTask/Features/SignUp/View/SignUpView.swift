import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    let onSuccess: () -> Void
    
    @State private var isNeedShowNameError = false
    @State private var isNeedShowEmailError = false
    @State private var isNeedShowPhoneError = false
    
    var body: some View {
        //        NavigationView {
        ZStack {
            VStack() {
                HeaderBannerView(title: LocalizeStrings.headerPostMsg)
                    .padding(.top, 1)
                ScrollView() {
                    VStack(spacing: 12) {
                        CustomTextField(
                            placeholder: LocalizeStrings.yourName,
                            text: $viewModel.name,
                            msg: viewModel.name.count < 2 ? LocalizeStrings.requiredField : nil,
                            isNeedShowError: $isNeedShowNameError
                        )
                        
                        CustomTextField(
                            placeholder: LocalizeStrings.email,
                            text: $viewModel.email,
                            msg: !viewModel.email.isValidEmail() ? LocalizeStrings.invalidEmail : nil,
                            isNeedShowError: $isNeedShowEmailError
                        )
                        
                        CustomTextField(
                            placeholder: LocalizeStrings.phone,
                            text: $viewModel.phone,
                            msg: !viewModel.phone.isValidPhoneNumber() ? LocalizeStrings.requiredField : nil,
                            isNeedShowError: $isNeedShowPhoneError,
                            isPhoneField: true
                        )
                    }
                    .padding()
                    HStack {
                        PositionSelectorView(viewModel: viewModel)
                        Spacer()
                    }
                    UploadPhotoView(viewModel: viewModel)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            isNeedShowNameError = true
                            isNeedShowEmailError = true
                            isNeedShowPhoneError = true
                            Task {
                                await viewModel.register()
                            }
                        }) {
                            Text(LocalizeStrings.signUpTab)
                                .padding(12)
                                .padding(.leading, 12)
                                .padding(.trailing, 12)
                                .background(Color(hex: "#F4E041"))
                                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                                .foregroundStyle(mainTextColor)
                                .cornerRadius(24)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    
                    Spacer()
                }
            }
            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            viewModel.getPositions()
        }
        .fullScreenCover(isPresented: $viewModel.showSuccess) {
            SuccessOrErrorRegiterView(message: LocalizeStrings.successfullyRegistered, icon: "successRegisterIcon") {
                viewModel.showSuccess = false
                onSuccess()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showError) {
            SuccessOrErrorRegiterView(message: viewModel.errorMessage, icon: "errorRegisterIcon") {
                viewModel.showError = false
            }
        }
    }
}


struct PositionSelectorView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizeStrings.selectYourPosition)
                .multilineTextAlignment(.leading)
                .padding()
                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                .foregroundStyle(mainTextColor)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.positions) { position in
                    Button(action: {
                        viewModel.selectedPositionId = position.id
                    }) {
                        HStack {
                            Circle()
                                .strokeBorder(
                                    viewModel.selectedPositionId == position.id ? Color(hex: "#00BDD3") : Color(hex: "#D0CFCF"),
                                    lineWidth: viewModel.selectedPositionId == position.id ? 4 : 1
                                )
                                .frame(width: 14, height: 14)
                            
                            Text(position.name)
                                .font(FontName.regular.fontNunitoSansFontWeightSans(18))
                                .foregroundStyle(mainTextColor)
                                .padding(.leading, 25)
                        }
                    }
                }
            }
            .padding(.leading, 40)
        }
    }
}

struct UploadPhotoView: View {
    @ObservedObject var viewModel: SignUpViewModel

    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var showPhotoPicker = false

    var borderColor: Color {
        viewModel.isNeedShowPhotoError ? .red : Color(hex: "#D0CFCF")
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showActionSheet = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                        .frame(height: 56)
                    HStack(spacing: 0) {
                        Text(LocalizeStrings.uploadYourPhoto)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(16))
                            .foregroundColor(borderColor)
                        Spacer()
                        Text(viewModel.selectedImage != nil ? LocalizeStrings.imageSelected : LocalizeStrings.upload)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(16))
                            .foregroundStyle(Color(hex: "#00BDD3"))
                    }
                    .padding()
                }
            }
            .confirmationDialog(LocalizeStrings.choosePhoto, isPresented: $showActionSheet, titleVisibility: .visible) {
                Button(LocalizeStrings.camera) {
                    showImagePicker = true
                    viewModel.isNeedShowPhotoError = false
                }
                Button(LocalizeStrings.gallery) {
                    showPhotoPicker = true
                    viewModel.isNeedShowPhotoError = false
                }
                Button(LocalizeStrings.cancel, role: .cancel) {}
            }

            if viewModel.isNeedShowPhotoError {
                Text(LocalizeStrings.photoRequired)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(12))
                    .foregroundColor(borderColor)
                    .padding(.leading, 16)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(selectedImageData: $viewModel.selectedImage)
                .background(Color.black)
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $viewModel.selectedImageItem, matching: .images)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImageData = image.jpegData(compressionQuality: 0)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var msg: String? = nil
    @Binding var isNeedShowError: Bool
    @State var isPhoneField: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var borderColor: Color {
        if isFocused {
            return Color(hex: "#00BDD3")
        } else if msg != nil && isNeedShowError {
            return .red
        } else {
            return Color(hex: "#D0CFCF")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
                    .frame(height: 56)
                VStack(alignment: .leading, spacing: 0) {
                    if !text.isEmpty {
                        Text(placeholder)
                            .font(FontName.regular.fontNunitoSansFontWeightSans(12))
                            .foregroundColor(borderColor)
                    }
                    
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .onChange(of: isFocused) {
                            isNeedShowError = true
                        }
                        .keyboardType(isPhoneField ? .phonePad : .emailAddress)
                }
                .frame(height: 56)
                .padding(.leading, 16)
            }
            
            if ((isNeedShowError && !isFocused) || isPhoneField), let msg = msg {
                Text(isPhoneField ? "+38 (XXX) XXX - XX - XX" : msg)
                    .font(FontName.regular.fontNunitoSansFontWeightSans(12))
                    .foregroundColor(borderColor)
                    .padding(.leading, 16)
            } else {
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .frame(height: 16)
            }
        }
        .animation(.easeInOut, value: isFocused)
    }
}

#Preview {
    SignUpView {}
}
