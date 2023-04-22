//
//  ContentView.swift
//  One-Finger-Rotation-Without-Value
//
//  Created by Matteo Fontana on 22/04/23.
//

import SwiftUI

struct RotatableElement: View {
    @State private var rotation: Angle = .zero
    @GestureState private var gestureRotation: Angle = .zero

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 200, height: 200)
            .rotationEffect(rotation + gestureRotation)
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
                    .onEnded { value in
                        let centerX = value.startLocation.x - 100
                        let centerY = value.startLocation.y - 100
                        
                        let startVector = CGVector(dx: centerX, dy: centerY)
                        
                        let endX = value.startLocation.x + value.translation.width - 100
                        let endY = value.startLocation.y + value.translation.height - 100
                        let endVector = CGVector(dx: endX, dy: endY)
                        
                        let angleDifference = atan2(startVector.dy * endVector.dx - startVector.dx * endVector.dy, startVector.dx * endVector.dx + startVector.dy * endVector.dy)
                        rotation = rotation + Angle(radians: -Double(angleDifference))
                    }
            )
    }
}

struct ContentView: View {
    var body: some View {
        RotatableElement()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
