//
//  InspectorView.swift
//  Mochi Diffusion
//
//  Created by Joshua Park on 12/19/22.
//

import SwiftUI
import StableDiffusion

struct InspectorView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        if let sdi = store.getSelectedImage() {
            ScrollView(.vertical) {
                Grid(alignment: .leading, horizontalSpacing: 4) {
                    InfoGridRow(
                        type: "Date",
                        text: dateFormatter.string(from: sdi.generatedDate),
                        showCopyToPromptOption: false)
                    InfoGridRow(
                        type: "Model",
                        text: sdi.model,
                        showCopyToPromptOption: false)
                    InfoGridRow(
                        type: "Size",
                        text: "\(sdi.width) x \(sdi.height)\(sdi.isUpscaled ? " (Converted to High Resolution)" : "")",
                        showCopyToPromptOption: false)
                    InfoGridRow(
                        type: "Prompt",
                        text: sdi.prompt,
                        showCopyToPromptOption: true,
                        callback: store.copyPromptToPrompt)
                    InfoGridRow(
                        type: "Negative Prompt",
                        text: sdi.negativePrompt,
                        showCopyToPromptOption: true,
                        callback: store.copyNegativePromptToPrompt)
                    InfoGridRow(
                        type: "Scheduler",
                        text: sdi.scheduler.rawValue,
                        showCopyToPromptOption: true,
                        callback: store.copySchedulerToPrompt)
                    InfoGridRow(
                        type: "Seed",
                        text: String(sdi.seed),
                        showCopyToPromptOption: true,
                        callback: store.copySeedToPrompt)
                    InfoGridRow(
                        type: "Steps",
                        text: String(sdi.steps),
                        showCopyToPromptOption: true,
                        callback: store.copyStepsToPrompt)
                    InfoGridRow(
                        type: "Guidance Scale",
                        text: String(sdi.guidanceScale),
                        showCopyToPromptOption: true,
                        callback: store.copyGuidanceScaleToPrompt)
                    InfoGridRow(
                        type: "Image Index",
                        text: String(sdi.imageIndex),
                        showCopyToPromptOption: false)
                }
                .frame(width: 350)
            }
            
            HStack(alignment: .center) {
                Button("Copy to Prompt") {
                    store.copyToPrompt()
                }
                Button("Copy") {
                    let info = getHumanReadableInfo(sdi: sdi)
                    let pb = NSPasteboard.general
                    pb.declareTypes([.string], owner: nil)
                    pb.setString(info, forType: .string)
                }
            }
        }
        else {
            Text("No info")
        }
    }
}

struct InfoGridRow: View {
    var type: String
    var text: String
    var showCopyToPromptOption: Bool
    var callback: (() -> ())? = nil
    
    var body: some View {
        GridRow {
            Text("")
            Text(type)
                .helpTextFormat()
        }
        GridRow {
            if showCopyToPromptOption {
                Button(action: {
                    guard let callbackFn = callback else { return }
                    callbackFn()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(Color.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            else {
                Text("")
            }
            
            Text(text)
                .selectableTextFormat()
        }
        Spacer().frame(height: 12)
    }
}

struct InspectorView_Previews: PreviewProvider {
    static var previews: some View {
        InspectorView()
    }
}
