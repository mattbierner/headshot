import Foundation
import Metal
import MobileCoreServices
import CoreGraphics
import ImageIO
import UIKit

private func makeImage(for texture: MTLTexture) -> CGImage? {
    let width = texture.width
    let height = texture.height
    let pixelByteCount = 4 * MemoryLayout<UInt8>.size
    let imageBytesPerRow = width * pixelByteCount
    let imageByteCount = imageBytesPerRow * height
    let imageBytes = UnsafeMutableRawPointer.allocate(byteCount: imageByteCount, alignment: pixelByteCount)
    defer {
        imageBytes.deallocate()
    }

    texture.getBytes(imageBytes,
                     bytesPerRow: imageBytesPerRow,
                     from: MTLRegionMake2D(0, 0, width, height),
                     mipmapLevel: 0)

    let colorSpace = CGColorSpace(name: CGColorSpace.genericRGBLinear)!
    let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue))
        
    guard let bitmapContext = CGContext(data: nil,
                                        width: width,
                                        height: height,
                                        bitsPerComponent: 8,
                                        bytesPerRow: imageBytesPerRow,
                                        space: colorSpace,
                                        bitmapInfo: bitmapInfo.rawValue) else { return nil }
    bitmapContext.data?.copyMemory(from: imageBytes, byteCount: imageByteCount)
    return bitmapContext.makeImage()
}

public func textureToImage(_ texture: MTLTexture) -> UIImage? {
    if let image = makeImage(for: texture) {
        return UIImage(cgImage: image)
    }
    return nil
}
