import SwiftUI

public enum FontName: String {
    case light
    case regular
    case bold
    case semiBold
    case extraBold
    
    fileprivate var systemFontWeight: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .bold: return .bold
        case .semiBold: return .semibold
        case .extraBold: return .black
        }
    }
    
    public var nunitoSansFontWeight: String {
        switch self {
        case .light: return "NunitoSans-Light"
        case .regular: return "NunitoSans-Regular"
        case .bold: return "NunitoSans-Bold"
        case .semiBold: return "NunitoSans-SemiBold"
        case .extraBold: return "NunitoSans-ExtraBold"
        }
    }

    public func fontNunitoSansFontWeightSans(_ fontSize: CGFloat = 14) -> Font {
        Font.fontNunitoSans(fontName: self, fontSize: fontSize)
    }
}

fileprivate extension Font {
    
    static func font(fontName: FontName = .regular, fontSize: CGFloat = 14) -> Font {
        return .system(size: fontSize, weight: fontName.systemFontWeight)
    }
    
    static func fontNunitoSans(fontName: FontName = .regular, fontSize: CGFloat = 14) -> Font {
        if let font = UIFont(name: fontName.nunitoSansFontWeight, size: fontSize) {
            return Font(font)
        } else {
            return .system(size: fontSize, weight: fontName.systemFontWeight)
        }
    }
}
