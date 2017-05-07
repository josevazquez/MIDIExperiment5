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



//struct S {
//    var a: Int
//    var b: Int
//    var c: (UInt8, UInt8)
//}
//
//let mem = malloc(42).bindMemory(to: UInt8.self, capacity: 42)
//
//memset(mem, 1, 42)
//
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
        setup()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    var midiClient: MIDIClientRef = 0
    var outPort:MIDIPortRef = 0
    var inPort:MIDIPortRef = 0

    var entity:MIDIEndpointRef = 0
    var source:MIDIEndpointRef = 0
    var destination:MIDIEndpointRef = 0
    
    func receiveMidiMessage(a:UInt8, b:UInt8, c:UInt8) {
        print("MIDI Message: \(a) \(b) \(c)")
    }
    
    func setup() {
        var status:OSStatus
        status = MIDIClientCreateWithBlock("TomboClient" as CFString, &midiClient) {
            midiNotificationPointer in
            let midiNotification = midiNotificationPointer.pointee
            print("Yay, got a message ----")
            print("  ID  : \(midiNotification.messageID)")
            print("  size: \(midiNotification.messageSize)")
            print("-----------------------")
        }
        guard status == noErr else {
            print("Error in: MIDIClientCreateWithBlock")
            return
        }
        
        status = MIDIInputPortCreateWithBlock(midiClient, "InputPort" as CFString, &inPort) {
            (packetListPointer, sourceReferencePointer) in

//            MIDIPacket *packet = &packetList->packet[0];
//            for (int i = 0; i < packetList->numPackets; ++i) {
//                ...
//                    packet = MIDIPacketNext(packet);
//            }
            
            let packetList:MIDIPacketList = packetListPointer.pointee
            var packet = packetList.packet
            var packetPtr = UnsafeMutablePointer<MIDIPacket>(&packet)
            var data:UnsafeMutablePointer<UInt8>

            for _ in 0..<packetList.numPackets {
                packet = packetPtr.pointee
                data = packetPtr.bindMemory(to: UInt8, capacity:3)
                //data = UnsafePointer<UInt8>(&packet.data)
                self.receiveMidiMessage(a:data[0], b:data[1], c:data[2])
                
                packetPtr = MIDIPacketNext(packetPtr)
            }

            let packetsPointer = pointerToLastField(ptr: packetListPointer, lastFieldType: type(of:packetList.packet),
                                                    outType: MIDIPacket.self, capacity: Int(packetList.numPackets))
            let dataPointer = pointerToLastField(ptr: packetsPointer, lastFieldType: type(of:packetsPointer.pointee.data),
                                                 outType: UInt8.self, capacity: 3)
            
            self.receiveMidiMessage(a:dataPointer[0], b:dataPointer[1], c:dataPointer[2])
        }
        guard status == noErr else {
            print("Error in: MIDIInputPortCreateWithBlock")
            return
        }

        status = MIDIOutputPortCreate(midiClient, "OutputPort" as CFString, &outPort)
        guard status == noErr else {
            print("Error in: MIDIInputPortCreateWithBlock")
            return
        }

        let deviceIndecies = 0..<MIDIGetNumberOfDevices()
        let devices = deviceIndecies.map { MIDIGetDevice($0) }
        var name: String = "Error"
        var launchPadPro:MIDIDeviceRef = 0
        print("indecies = \(deviceIndecies.count)")
        print(MIDIGetNumberOfDevices())

        for device in devices {
            print("=====================\n")
            print(device.description)
        }
        
        for device in devices {
            name = device.name ?? "Error"
            print("[\(device)]: \(name)")
            if name == kLaunchPadPro {
                launchPadPro = device
                break
            }
        }
        guard name == kLaunchPadPro else {
            print("Error in: Search for LaunchPad Pro device")
            return
        }
        
        entity = MIDIDeviceGetEntity(launchPadPro, 0)
        print("Entitiy = \(entity.description)")
        
        source = MIDIEntityGetSource(entity, 0)
        print("Source = \(source.description)")

        print("inPort = \(inPort.description)")
        
        destination = MIDIEntityGetDestination(entity, 0)
        print("passed the guantlet")
        MIDIPortConnectSource(inPort, source, nil)
    }
}

/*

    NSString *myDeviceName = @"Launchpad Pro";
    MIDIDeviceRef myDevice = 0;
    
    int numberOfDevices = (int)MIDIGetNumberOfDevices();
    
    for (int i = 0; i < numberOfDevices; i++) {
    MIDIDeviceRef device = MIDIGetDevice(i);
    
    if (device) {
    CFStringRef name;
    
    if (MIDIObjectGetStringProperty(device, kMIDIPropertyName, &name) == noErr) {
    NSString *deviceName = (__bridge NSString *)name;
    NSLog(@"DEVICE: %@", deviceName);
    if ([myDeviceName isEqualToString:deviceName]) {
    myDevice = device;
    NSLog(@"MATCH");
    
    CFRelease(name);
    
    break;
    }
    }
    
    CFRelease(name);
    }
    }
    
    
    
    entity = MIDIDeviceGetEntity(myDevice, 0);
    source = MIDIEntityGetSource(entity, 0);
    
    MIDIPortConnectSource(inputPort, source, NULL);
    
    destination = MIDIEntityGetDestination(entity, 0);
    
    [self setCurrentColor:72];
    pickingState = notPicking;
    
    }
} // */

