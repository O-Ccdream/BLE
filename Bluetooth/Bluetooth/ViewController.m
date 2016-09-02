//
//  ViewController.m
//  Bluetooth
//
//  Created by ChangChen on 16/9/1.
//  Copyright © 2016年 ccdream. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],, nil]
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    _dicoveredPeripherals = [[NSMutableArray alloc] init];
    PowerArray = [[NSMutableArray alloc]init];

}

#pragma mark - public methods

- (void)startScan
{
//    [super startScan];
//    
//    if (nil != _manager) {
//        [self failedToStartScan];
//        return;
//    }
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

//- (void)stopScan
//{
//    [super stopScan];
//    
//    [_manager stopScan];
//    
//    [self successToStopScan];
//}

- (void)readRSSI
{
    CBPeripheral *per = [RSSItimer userInfo];
    [per readRSSI];
    NSLog(@"test");
}
- (void)peripheralReadRSSI:(CBPeripheral *)peripheral{
    
}


- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSLog(@"read is%ld",(long)[RSSI integerValue]);
    float Long = [self getDistance:RSSI];
    NSLog(@" %f米",Long);
    InfoLbael.text = [NSString stringWithFormat:@"距离是 -- %.1f米 强度是 -- %ld",Long,(long)[RSSI integerValue]];

}

//距离数据算法
-(CGFloat)getDistance:(NSNumber *)RSSI
{
    float power = (abs([RSSI intValue])-70)/(10*2.0);
    
    NSString *powerstring = [NSString stringWithFormat:@"%f",power];
    
    [PowerArray addObject:powerstring];
    
    if(PowerArray.count>10)
    {
        [PowerArray removeObjectAtIndex:0];
    }
        NSLog(@"PowerArray =%@",PowerArray);
        
        NSNumber *avg = [PowerArray valueForKeyPath:@"@avg.floatValue"];
        power = [avg floatValue];
    
    
    return powf(10.0f, power);
}

#pragma mark - core bluetooth central manager delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self scanPeripherals];
            break;
        default:
//            [self failedToStartScan];
            _manager = nil;
            NSLog(@"Central Manager did change state");
            break;
    }
}

- (void)scanPeripherals
{
    if (_manager.state != CBCentralManagerStatePoweredOn)
        NSLog (@"CoreBluetooth not initialized correctly!");
    else {
        NSLog(@"开始扫描");
        [_manager scanForPeripheralsWithServices:nil options:nil];
        InfoLbael.text = @"扫描设备中......";
//        [_manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"99025E68-5CE8-8130-3E24-12742B680BA1"]] options:nil];
//99025E68-5CE8-8130-3E24-12742B680BA1
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@", peripheral);
    
    //加入到被发现的设备列表中
    if(![_dicoveredPeripherals containsObject:peripheral])
    {
        [_dicoveredPeripherals addObject:peripheral];
        [_manager connectPeripheral:peripheral options:nil];
    }
    float Long = [self getDistance:RSSI];
    NSLog(@"距离是 -- %f米",Long);
//    InfoLbael.text = [NSString stringWithFormat:@"距离是 -- %f米",Long];

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"设备已连接");
    InfoLbael.text = @"设备已连接";

    peripheral.delegate = self;
    
    if(!RSSItimer){
        RSSItimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                   selector:@selector(readRSSI)
                                                    userInfo:peripheral
                                                     repeats:0.1];
        [[NSRunLoop currentRunLoop] addTimer:RSSItimer forMode:NSDefaultRunLoopMode];

    }
    // Search only for services that match our UUID
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:self.uuid]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral disConnected : %@", error);
    
    [_manager cancelPeripheralConnection:peripheral];
    peripheral.delegate = nil;
    [_dicoveredPeripherals removeObject:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Connect error!");
    
    peripheral.delegate = nil;
    [_dicoveredPeripherals removeObject:peripheral];
    peripheral = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
