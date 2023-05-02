//
//  AutoRotation.swift
//  One-Finger-Rotation-Without-Value
//
//  Created by Matteo Fontana on 30/04/23.
//

import SwiftUI

struct AutoRotation: ViewModifier {
    @State private var rotationAngle: Angle = .zero
    @GestureState private var gestureRotation: Angle = .zero
    @Binding var autoRotationSpeed: Double
    @Binding var autoRotationActive: Bool
    
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1 / 60, repeats: true) { _ in
            if autoRotationActive && gestureRotation == .zero {
                rotationAngle = rotationAngle + Angle(degrees: autoRotationSpeed / 60)
            }
        }
    }
    
    init(rotationAngle: Angle = .degrees(0.0), autoRotationSpeed: Binding<Double>, autoRotationActive: Binding<Bool>) {
        _rotationAngle = State(initialValue: rotationAngle)
        _autoRotationSpeed = autoRotationSpeed
        _autoRotationActive = autoRotationActive
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(rotationAngle + gestureRotation)
            .gesture(
                DragGesture()
                    .updating($gestureRotation) { value, state, _ in
                        let centerX = value.startLocation.x - 100
                        let centerY = value.startLocation.y - 100
                        
                        let startVector = CGVector(dx: centerX, dy: centerY)
                        
                        let endX = value.startLocation.x + value.translation.width - 100
                        let endY = value.startLocation.y + value.translation.height - 100
                        let endVector = CGVector(dx: endX, dy: endY)
                        
                        let angleDifference = atan2(startVector.dy * endVector.dx - startVector.dx * endVector.dy, startVector.dx * endVector.dx + startVector.dy * endVector.dy)
                        state = Angle(radians: -Double(angleDifference))
                    }
                    //Drag gesture of rotation when ended
                    .onEnded { value in
                        let centerX = value.startLocation.x - 100
                        let centerY = value.startLocation.y - 100
                        
                        let startVector = CGVector(dx: centerX, dy: centerY)
                        
                        let endX = value.startLocation.x + value.translation.width - 100
                        let endY = value.startLocation.y + value.translation.height - 100
                        let endVector = CGVector(dx: endX, dy: endY)
                        
                        let angleDifference = atan2(startVector.dy * endVector.dx - startVector.dx * endVector.dy, startVector.dx * endVector.dx + startVector.dy * endVector.dy)
                        rotationAngle = rotationAngle + Angle(radians: -Double(angleDifference))
                    }
            )
            .onAppear {
                _ = timer
            }
            .onDisappear {
                timer.invalidate()
            }
    }
}

extension View {
    func autoRotation(rotationAngle: Angle? = nil, autoRotationSpeed: Binding<Double>? = nil, autoRotationActive: Binding<Bool>? = nil) -> some View {
        let effect = AutoRotation(
            rotationAngle: rotationAngle ?? .degrees(0.0),
            autoRotationSpeed: autoRotationSpeed ?? .constant(20.0),
            autoRotationActive: autoRotationActive ?? .constant(true)
        )
        return self.modifier(effect)
    }
}