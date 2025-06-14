
import SwiftUI

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
