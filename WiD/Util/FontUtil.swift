//
//  FontUtil.swift
//  WiD
//
//  Created by jjkim on 2023/12/18.
//

import Foundation
import SwiftUI

extension View {
    func labelSmall() -> some View {
        return self.font(.system(size: 16, weight: .thin))
    }
    
    func labelMedium() -> some View {
        return self.font(.system(size: 18, weight: .thin))
    }
    
    func labelLarge() -> some View {
        return self.font(.system(size: 20, weight: .thin))
    }
    
    func bodySmall() -> some View {
        return self.font(.system(size: 16, weight: .medium))
    }
    
    func bodyMedium() -> some View {
        return self.font(.system(size: 18, weight: .medium))
    }
    
    func bodyLarge() -> some View {
        return self.font(.system(size: 20, weight: .medium))
    }
    
    func titleSmall() -> some View {
        return self.font(.system(size: 16, weight: .bold))
    }
    
    func titleMedium() -> some View {
        return self.font(.system(size: 18, weight: .bold))
    }
    
    func titleLarge() -> some View {
        return self.font(.system(size: 20, weight: .bold))
    }
    
    
}
