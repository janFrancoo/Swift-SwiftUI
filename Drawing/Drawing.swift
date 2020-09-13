//
//  View.swift
//  DrawingTest
//
//  Created by JanFranco on 5.09.2020.
//  Copyright © 2020 janfranco. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    private var lineArray = [Line]()
    private var strokeColor = UIColor.black
    private var strokeWidth: Float = 5.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lineArray.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        guard var lastLine = lineArray.popLast() else { return }
        lastLine.points.append(point)
        lineArray.append(lastLine)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(inContext: context)
    }
    
    func draw(inContext context: CGContext) {
        lineArray.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            
            context.strokePath()
        }
    }
    
    func undo() {
        _ = lineArray.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lineArray.removeAll()
        setNeedsDisplay()
    }
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func exportDrawing() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        draw(inContext: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
