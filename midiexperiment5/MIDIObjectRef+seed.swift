//
//  MIDIObjectRef+seed.swift
//  midiexperiment5
//
//  Created by Jose Vazquez on 2/28/17.
//  Copyright © 2017 Jose Vazquez. All rights reserved.
//

import Foundation
import CoreMIDI


extension MIDIObjectRef {
    
    private func string(for property:CFString) -> String? {
        var param: Unmanaged<CFString>?
        if MIDIObjectGetStringProperty(self, property, &param) == noErr {
            return param?.takeUnretainedValue() as? String
        }
        return nil
    }
    
    private func int(for property:CFString) -> Int? {
        var param: Int32 = 0
        if MIDIObjectGetIntegerProperty(self, property, &param) == noErr {
            return Int(param)
        }
        return nil
    }
    
    
    /// device/entity/endpoint property, string
    
    /// Devices, entities, and endpoints may all have names.  The recommended way to display an
    /// endpoint's name is to ask for the endpoint name, and display only that name if it is
    /// unique.  If it is non-unique, prepend the device name.
    
    /// A setup editor may allow the user to set the names of both driver-owned and external
    /// devices.
    var name : String? {
        return string(for: kMIDIPropertyName)
    }
    
    
    /// device/endpoint property, string
    
    /// Drivers should set this property on their devices.
    
    /// Setup editors may allow the user to set this property on external devices.

    /// Creators of virtual endpoints may set this property on their endpoints.
    var manufacturer : String? {
        return string(for: kMIDIPropertyManufacturer)
    }
    
    
    /// device/endpoint property, string
    
    /// Drivers should set this property on their devices.
    
    /// Setup editors may allow the user to set this property on external devices.
    
    /// Creators of virtual endpoints may set this property on their endpoints.
    var model : String? {
        return string(for: kMIDIPropertyModel)
    }
    
    
    /// devices, entities, endpoints all have unique ID's, integer
    
    /// The system assigns unique ID's to all objects.  Creators of virtual endpoints may set
    /// this property on their endpoints, though doing so may fail if the chosen ID is not
    /// unique.
    var uniqueID : Int? {
        return int(for: kMIDIPropertyUniqueID)
    }

    
    /// device/entity property, integer
    
    /// The entity's system-exclusive ID, in user-visible form
    
    /// Drivers may set this property on their devices or entities.
    
    /// Setup editors may allow the user to set this property on external devices.
    var deviceID : Int? {
        return int(for: kMIDIPropertyDeviceID)
    }

    
    /// endpoint property, integer
    
    /// The value is a bitmap of channels on which the object receives: 1=ch 1, 2=ch 2, 4=ch 3
    /// ... 0x8000=ch 16.
    
    /// Drivers may set this property on their entities or endpoints.
    
    /// Setup editors may allow the user to set this property on external endpoints.
    
    /// Virtual destination may set this property on their endpoints.
    var receiveChannels : Int? {
        return int(for: kMIDIPropertyReceiveChannels)
    }

    
    /// endpoint property, integer
    
    /// The value is a bitmap of channels on which the object transmits: 1=ch 1, 2=ch 2, 4=ch 3
    /// ... 0x8000=ch 16.
    var transmitChannels : Int? {
        return int(for: kMIDIPropertyTransmitChannels)
    }

    
    /// device/entity/endpoint property, integer
    
    /// Set by the owning driver; should not be touched by other clients.
    /// The value is the maximum rate, in bytes/second, at which sysex messages may
    /// be sent reliably to this object. (The default value is 3125, as with MIDI 1.0)
    var maxSysExSpeed : Int? {
        return int(for: kMIDIPropertyMaxSysExSpeed)
    }
 
    
    /// device/entity/endpoint property, integer
    
    /// Set by the owning driver; should not be touched by other clients. If it is non-zero,
    /// then it is a recommendation of how many microseconds in advance clients should schedule
    /// output. Clients should treat this value as a minimum.  For devices with a non-zero
    /// advance schedule time, drivers will receive outgoing messages to the device at the time
    /// they are sent by the client, via MIDISend, and the driver is responsible for scheduling
    /// events to be played at the right times according to their timestamps.
    
    /// As of CoreMIDI 1.3, this property may also be set on virtual destinations (but only the
    /// creator of the destination should do so). When a client sends to a virtual destination
    /// with an advance schedule time of 0, the virtual destination receives its messages at
    /// their scheduled delivery time.  If a virtual destination has a non-zero advance schedule
    /// time, it receives timestamped messages as soon as they are sent, and must do its own
    /// internal scheduling of received events.
    var advanceScheduleTimeMuSec : Int? {
        return int(for: kMIDIPropertyAdvanceScheduleTimeMuSec)
    }
    
    
    /// entity/endpoint property, integer
    
    /// 0 if there are external MIDI connectors, 1 if not.
    var isEmbeddedEntity : Int? {
        return int(for: kMIDIPropertyIsEmbeddedEntity)
    }

    
    /// entity/endpoint property, integer
    
    /// 1 if the endpoint broadcasts messages to all of the other endpoints in the device, 0 if
    /// not.  Set by the owning driver; should not be touched by other clients.
    var propertyIsBroadcast : Int? {
        return int(for: kMIDIPropertyIsBroadcast)
    }
  
    
    /// device property, integer
    
    /// Some MIDI interfaces cannot route MIDI realtime messages to individual outputs; they are
    /// broadcast.  On such devices the inverse is usually also true -- incoming realtime
    /// messages cannot be identified as originating from any particular source.
    
    /// When this property is set on a driver device, it signifies the 0-based index of the
    /// entity on which incoming realtime messages from the device will appear to have
    /// originated from.
    var singleRealtimeEntity : Int? {
        return int(for: kMIDIPropertySingleRealtimeEntity)
    }
    
    
    /// device/entity/endpoint property, integer or CFDataRef
    
    /// UniqueID of an external device/entity/endpoint attached to this one. As of Mac OS X
    /// 10.3, Audio MIDI Setup maintains endpoint-to-external endpoint connections (in 10.2, it
    /// connected devices to devices).
    
    /// The property is non-existant or 0 if there is no connection.
    
    /// Beginning with CoreMIDI 1.3 (Mac OS X 10.2), this property may also be a CFDataRef containing an array of
    /// big-endian SInt32's, to allow specifying that a driver object connects to multiple
    /// external objects (via MIDI thru-ing or splitting).
    
    /// This property may also exist for external devices/entities/endpoints, in which case it
    /// signifies a MIDI Thru connection to another external device/entity/endpoint (again,
    /// it is strongly recommended that it be an endpoint).
    /// - Warning: This might return a CFDataRef
    
    // TODO: Warning: This might return a CFDataRef
    var connectionUniqueID : Int? {
        return int(for: kMIDIPropertyConnectionUniqueID)
    }
    
    
    /// device/entity/endpoint property, integer
    
    /// 1 = device is offline (is temporarily absent), 0 = present. Set by the owning driver, on
    /// the device; should not be touched by other clients. Property is inherited from the
    /// device by its entities and endpoints.
    var offline : Int? {
        return int(for: kMIDIPropertyOffline)
    }

    
    /// device/entity/endpoint property, integer
    
    /// 1 = endpoint is private, hidden from other clients. May be set on a device or entity,
    /// but they will still appear in the API; only affects whether the owned endpoints are
    /// hidden.
    var isPrivate : Int? {
        return int(for: kMIDIPropertyPrivate)
    }

    
    /// device/entity/endpoint property, string
    
    /// Name of the driver that owns a device. Set by the owning driver, on the device; should
    /// not be touched by other clients. Property is inherited from the device by its entities
    /// and endpoints.
    var driverOwner : Int? {
        return int(for: kMIDIPropertyDriverOwner)
    }


    
}

//=============================================================================
//	Property name constants
//=============================================================================





//
///*!
//	@constant		kMIDIPropertyImage
//	@discussion
// device property, CFStringRef which is a full POSIX path to a device or external device's
// icon, stored in any standard graphic file format such as JPEG, GIF, PNG and TIFF are all
// acceptable.  (See CFURL for functions to convert between POSIX paths and other ways of
// specifying files.)  The image's maximum size should be 128x128.
// 
// Drivers should set the icon on the devices they add.
// 
// A studio setup editor should allow the user to choose icons for external devices.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyImage: CFString
//
///*!
//	@constant		kMIDIPropertyDriverVersion
//	@discussion
// device/entity/endpoint property, integer, returns the driver version API of the owning
// driver (only for driver- owned devices).  Drivers need not set this property;
// applications should not write to it.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyDriverVersion: CFString
//
///*!
//	@constant		kMIDIPropertySupportsGeneralMIDI
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity implements
// the General MIDI specification.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertySupportsGeneralMIDI: CFString
//
///*!
//	@constant		kMIDIPropertySupportsMMC
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity implements
// the MIDI Machine Control portion of the MIDI specification.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertySupportsMMC: CFString
//
///*!
//	@constant		kMIDIPropertyCanRoute
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity can route
// MIDI messages to or from other external MIDI devices (as with MIDI patch bays). This
// should NOT be set on devices which are controlled by drivers.
// */
//@available(OSX 10.0, *)
//public let kMIDIPropertyCanRoute: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesClock
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity  responds
// to MIDI beat clock messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesClock: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesMTC
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity responds
// to MIDI Time Code messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesMTC: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesNotes
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity responds
// to MIDI Note On messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesNotes: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesProgramChanges
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity responds
// to MIDI program change messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesProgramChanges: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesBankSelectMSB
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity responds
// to MIDI bank select MSB messages (control 0).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesBankSelectMSB: CFString
//
///*!
//	@constant		kMIDIPropertyReceivesBankSelectLSB
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity responds
// to MIDI bank select LSB messages (control 32).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyReceivesBankSelectLSB: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsClock
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI beat clock messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsClock: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsMTC
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI Time Code messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsMTC: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsNotes
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI note messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsNotes: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsProgramChanges
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI program change messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsProgramChanges: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsBankSelectMSB
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI bank select MSB messages (control 0).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsBankSelectMSB: CFString
//
///*!
//	@constant		kMIDIPropertyTransmitsBankSelectLSB
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity transmits
// MIDI bank select LSB messages (control 32).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyTransmitsBankSelectLSB: CFString
//
///*!
//	@constant		kMIDIPropertyPanDisruptsStereo
//	@discussion
// device/entity property, integer (0/1). Indicates whether the MIDI pan messages (control
// 10), when sent to the device or entity, cause undesirable effects when playing stereo
// sounds (e.g. converting the signal to mono).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyPanDisruptsStereo: CFString
//
///*!
//	@constant		kMIDIPropertyIsSampler
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity plays
// audio samples in response to MIDI note messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyIsSampler: CFString
//
///*!
//	@constant		kMIDIPropertyIsDrumMachine
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity's sound
// presets tend to be collections of non-transposable samples (e.g. drum kits).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyIsDrumMachine: CFString
//
///*!
//	@constant		kMIDIPropertyIsMixer
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity mixes
// external audio signals, controlled by MIDI messages.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyIsMixer: CFString
//
///*!
//	@constant		kMIDIPropertyIsEffectUnit
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device or entity is
// primarily a MIDI-controlled audio effect unit (i.e. does not generate sound on its own).
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyIsEffectUnit: CFString
//
///*!
//	@constant		kMIDIPropertyMaxReceiveChannels
//	@discussion
// device/entity property, integer (0-16). Indicates the maximum number of MIDI channels on
// which a device may simultaneously receive MIDI Channel Messages. Common values are 0
// (devices which only respond to System Messages), 1 (non-multitimbral devices), and 16
// (fully multitimbral devices). Other values are possible, for example devices which are
// multi-timbral but have fewer than 16 "parts".
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyMaxReceiveChannels: CFString
//
///*!
//	@constant		kMIDIPropertyMaxTransmitChannels
//	@discussion
// device/entity property, integer (0/1). Indicates the maximum number of MIDI channels on
// which a device may simultaneously transmit MIDI Channel Messages. Common values are 0, 1
// and 16.
// */
//@available(OSX 10.2, *)
//public let kMIDIPropertyMaxTransmitChannels: CFString
//
///*!
//	@constant		kMIDIPropertyDriverDeviceEditorApp
//	@discussion
// device property, string, contains the full path to an application which knows how to
// configure this driver-owned devices. Drivers may set this property on their owned
// devices. Applications must not write to it.
// */
//@available(OSX 10.3, *)
//public let kMIDIPropertyDriverDeviceEditorApp: CFString
//
///*!
//	@constant		kMIDIPropertySupportsShowControl
//	@discussion
// device/entity property, integer (0/1). Indicates whether the device implements the MIDI
// Show Control specification.
// */
//@available(OSX 10.4, *)
//public let kMIDIPropertySupportsShowControl: CFString
//
///*!
//	@constant		kMIDIPropertyDisplayName
//	@discussion
// device/entity/endpoint property, string.
// 
// Provides the Apple-recommended user-visible name for an endpoint, by combining the
// device and endpoint names.
// 
// For objects other than endpoints, the display name is the same as the name.
// */
//@available(OSX 10.4, *)
//public let kMIDIPropertyDisplayName: CFString
