//
//  MetalView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState
    var texture: MTLTexture
    @Binding var time: Float

    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView(frame: .zero, device: device)
        metalView.delegate = context.coordinator
        metalView.framebufferOnly = false
        metalView.autoResizeDrawable = true
        return metalView
    }

    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.time = time
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var time: Float = 0.0

        init(_ parent: MetalView) {
            self.parent = parent
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle view size or orientation changes
        }

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor else {
                return
            }

            let commandBuffer = parent.commandQueue.makeCommandBuffer()!
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
            commandEncoder.setRenderPipelineState(parent.pipelineState)
            commandEncoder.setFragmentTexture(parent.texture, index: 0)
            commandEncoder.setFragmentBytes(&time, length: MemoryLayout<Float>.size, index: 0)
            
            // Draw call (full screen quad)
            commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
