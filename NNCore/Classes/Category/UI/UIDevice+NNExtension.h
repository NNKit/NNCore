//
//  UIDevice+NNExtension.h
//  NNCore
//
//  more info https://github.com/ibireme/YYKit/blob/master/YYKit/Base/UIKit/UIDevice%2BYYAdd.h
//  Created by XMFraker on 2017/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIDevice`.
 */
@interface UIDevice (NNExtension)


#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)
+ (double)systemVersion;

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL isPad;

/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL isSimulator;

/// Whether the device is jailbroken.
@property (nonatomic, readonly) BOOL isJailbroken;

/// Wherher the device can make phone calls.
@property (nonatomic, readonly) BOOL canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *machineModelName;

/// The System's startup time.
@property (nonatomic, readonly) NSDate *systemUptime;

#pragma mark - Network Information

///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nullable, nonatomic, readonly) NSString *ipAddressCell;


/**
 Network traffic type:
 
 WWAN: Wireless Wide Area Network.
       For example: 3G/4G.
 
 WIFI: Wi-Fi.
 
 AWDL: Apple Wireless Direct Link (peer-to-peer connection).
       For exmaple: AirDrop, AirPlay, GameKit.
 */
typedef NS_OPTIONS(NSUInteger, NNetworkTrafficType) {
    NNetworkTrafficTypeWWANSent     = 1 << 0,
    NNetworkTrafficTypeWWANReceived = 1 << 1,
    NNetworkTrafficTypeWiFiSent     = 1 << 2,
    NNetworkTrafficTypeWiFiReceived = 1 << 3,
    NNetworkTrafficTypeAWDLSent     = 1 << 4,
    NNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    NNetworkTrafficTypeWWAN = NNetworkTrafficTypeWWANSent | NNetworkTrafficTypeWWANReceived,
    NNetworkTrafficTypeWiFi = NNetworkTrafficTypeWiFiSent | NNetworkTrafficTypeWiFiReceived,
    NNetworkTrafficTypeAWDL = NNetworkTrafficTypeAWDLSent | NNetworkTrafficTypeAWDLReceived,
    
    NNetworkTrafficTypeALL = NNetworkTrafficTypeWWAN |
                              NNetworkTrafficTypeWiFi |
                              NNetworkTrafficTypeAWDL,
};

/**
 Get device network traffic bytes.
 
 @discussion This is a counter since the device's last boot time.
 Usage:
 
     uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:NNetworkTrafficTypeALL];
     NSTimeInterval time = CACurrentMediaTime();
     
     uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
     
     _lastBytes = bytes;
     _lastTime = time;
 
 
 @param types traffic types
 @return bytes counter.
 */
- (uint64_t)getNetworkTrafficBytes:(NNetworkTrafficType)types;

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpace;

/// Free disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceFree;

/// Used disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger cpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float cpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *cpuUsagePerProcessor;

@end

NS_ASSUME_NONNULL_END


#ifndef SYSTEM_VERSION
    #define SYSTEM_VERSION [UIDevice systemVersion]
#endif

/// ========================================
/// @name   相关版本宏
/// ========================================

#ifndef iOS7Later
    #define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#endif

#ifndef iOS8Later
    #define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#endif

#ifndef iOS9Later
    #define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#endif

#ifndef iOS10Later
    #define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
#endif

#ifndef iOS11Later
    #define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#endif
