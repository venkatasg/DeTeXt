// Extensions to UIImage

import UIKit

extension UIImage {
    
    var averageColor: UIColor? {
           guard let inputImage = CIImage(image: self) else { return nil }
           let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

           guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
           guard let outputImage = filter.outputImage else { return nil }

           var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
           context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

           return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
       }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    
    
    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
 
        let scaledImageSize:CGSize = CGSize(width: size.width * 0.8, height: size.height * 0.8)
        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 1.0)

        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func resize(newSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }

        return image.withRenderingMode(self.renderingMode)
    }
    
    
    func toCVPixelBuffer() -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil

        let attr = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, attr, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let bitmapContext = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: bitmapInfo.rawValue)!

        guard let cg = self.cgImage else {
            return nil
        }

        bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

//overlays black background over image
func overlayBlackBg(image: UIImage) -> UIImage {
    let newFrameWidth: CGFloat
    let newFrameHeight: CGFloat
    if image.size.width > image.size.height {
        newFrameWidth = image.size.width * 1.2
        newFrameHeight = (newFrameWidth / 1.5)
    }
    else {
        newFrameHeight = image.size.height * 1.2
        newFrameWidth = (newFrameHeight * 1.5)
    }
    
    // Draw black background
    let background = UIImage(color: .black, size: CGSize(width: newFrameWidth, height: newFrameHeight))!
    // Find where to start drawing
    let draw_position = CGPoint(x: newFrameWidth/2 - image.size.width/2, y: newFrameHeight/2 - image.size.height/2)
    
    let renderer = UIGraphicsImageRenderer(size: background.size)
    return renderer.image { context in
        background.draw(in: CGRect(origin: CGPoint.zero, size: background.size))
        image.draw(in: CGRect(origin: draw_position, size: image.size))
    }
}

// invert the colors when in light mode
func invertColors(image: UIImage) -> UIImage {
    let beginImage = CIImage(image: image)
    let filter = CIFilter(name: "CIColorInvert")
    filter?.setValue(beginImage, forKey: kCIInputImageKey)
    let newImage = UIImage(ciImage: (filter?.outputImage!)!)
    return newImage
}
