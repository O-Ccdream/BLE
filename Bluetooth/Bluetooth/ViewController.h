//
//  ViewController.h
//  Bluetooth
//
//  Created by ChangChen on 16/9/1.
//  Copyright © 2016年 ccdream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
     CBCentralManager* _manager;
    
    NSMutableArray* _dicoveredPeripherals;
    
    __weak IBOutlet UILabel *InfoLbael;
    
    NSTimer *RSSItimer;
    
    NSMutableArray *PowerArray;
}

@end

