import SwiftUI

struct Pie: Shape {
    
    var startAngle: Angle // A geometric angle whose value can be accessed either in radians or degrees.
    var endAngle: Angle
    var clockWise = false
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY) // get the center coordinate
        let radius = (min(rect.width, rect.height) / 2)
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        // drawing process
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockWise
        )
        path.addLine(to: center)
        
        return path
    }
}
