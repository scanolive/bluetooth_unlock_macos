#!/usr/bin/swift
import IOBluetooth
//thank lapfelix for BluetoothConnector;  https://github.com/lapfelix/BluetoothConnector

let hardcodedAddress : String? = nil//"12-34-56-78-90-ab"

func printHelp() {
    print("Usage:check_bluetooth.swift 00-00-00-00-00-00\n\nGet the MAC address from the list below (if your device is missing, pair it with your computer first):");
    IOBluetoothDevice.pairedDevices().forEach({(device) in
        guard let device = device as? IOBluetoothDevice,
        let addressString = device.addressString,
        let deviceName = device.name
        else { return }
        print("\(addressString) - \(deviceName)")
    })
}

if (CommandLine.arguments.count == 2 || hardcodedAddress != nil) {
    let deviceAddress : String? = hardcodedAddress == nil ? CommandLine.arguments[1] : nil
    guard let bluetoothDevice = IOBluetoothDevice(addressString: hardcodedAddress ?? deviceAddress) else {
        print("Device not found")
        exit(-2)
    }
    
    if !bluetoothDevice.isPaired() {
        print("Not paired to device")
        exit(-4)
    }

//  以下注释掉的部分是检测连接性的同时也检测RSSI值,这个据说这个与距离远近有关,
//	但由于设备差异这个值与距离的关系不固定,所以这个功能没启用
//	感兴趣的可测试下自己设备RSSI值与距离的关系
/*  if bluetoothDevice.isConnected() {
		if (abs(bluetoothDevice.rawRSSI()) > 60){
			print(0)
			exit(0)
		}
		else {
			print(1)
		}
    }
    else {
		bluetoothDevice.openConnection()
		if bluetoothDevice.isConnected(){
			if (abs(bluetoothDevice.rawRSSI()) > 60){
				print(0)
				exit(0)
			}
			else {	
				print(1)
				exit(0)
			}
		}
		else {
			print(0)
			exit(0)
		}
    }
*/

	if bluetoothDevice.isConnected() {
		print(1)
		exit(0)
	}
	else {
		bluetoothDevice.openConnection()
		if bluetoothDevice.isConnected(){
			print(1)
			exit(0)
		}			
		else {		
			print(0)
			exit(0)
		}
	}
}
else {
    printHelp()
    exit(-3)
}
