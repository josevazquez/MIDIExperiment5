//
//  ViewController.swift
//  midiexperiment5
//
//  Created by Jose Vazquez on 2/21/17.
//  Copyright © 2017 Jose Vazquez. All rights reserved.
//

import Cocoa
import CoreMIDI

let kLaunchPadPro = "Launchpad Pro"

struct S {
    var a: Int
    var b: Int
    var c: (UInt8, UInt8)
}

//let mem = malloc(42).bindMemory(to: UInt8.self, capacity: 42)

//memset(mem, 1, 42)

//let sptr = UnsafeRawPointer(mem).bindMemory(to: S.self, capacity: 1)
//print(sptr.pointee)


func pointerToLastField<StructType, LastFieldType, OutType>(ptr: UnsafePointer<StructType>, lastFieldType: LastFieldType.Type, outType: OutType.Type, capacity: Int) -> UnsafePointer<OutType> {
    let structSize = MemoryLayout<StructType>.size
    let lastFieldSize = MemoryLayout<LastFieldType>.size
    let delta = structSize - lastFieldSize
    
    let raw = UnsafeRawPointer(ptr)
    let offset = raw + delta
    let converted = offset.bindMemory(to: OutType.self, capacity: capacity)
    return converted
}



//let lastPtr = pointerToLastField(ptr: sptr, lastFieldType: type(of: sptr.pointee.c), outType: UInt8.self, capacity: 20)
//print(lastPtr[0], lastPtr[1], lastPtr[2])

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

