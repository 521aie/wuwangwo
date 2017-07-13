/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice-Hardware.h"
#import <sys/utsname.h>
// Add support for subscripting to the iOS 5 SDK.
// reference from http://stackoverflow.com/questions/11658669/how-to-enable-the-new-objective-c-object-literals-on-ios
// also found from github https://github.com/tewha/iOS-Subscripting 

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
@interface NSDictionary(subscripts)
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSMutableDictionary(subscripts)
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end

@interface NSArray(subscripts)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface NSMutableArray(subscripts)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
@end

@implementation NSDictionary(subscripts)
- (id)objectForKeyedSubscript:(id)key;
{
    return [self objectForKey:key];
}
@end

#endif

@implementation UIDevice (Hardware)
/*
 Platforms
 
 iFPGA ->        ??

 iPhone1,1 ->    iPhone 1, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/GSM, N89
 iPhone3,2 ->    iPhone 4/GSM Rev A, N90
 iPhone3,3 ->    iPhone 4/CDMA, N92
 iPhone4,1 ->    iPhone 4S/GSM+CDMA, N94
 iPhone5,1 ->    iPhone 5/GSM, N41
 iPhone5,2 ->    iPhone 5/GSM+CDMA, N42
 iPhone5,3 ->    iPhone 5C/GSM, N48
 iPhone5,4 ->    iPhone 5C/GSM+CDMA, N49
 iPhone6,1 ->    iPhone 5S/GSM, N51
 iPhone6,2 ->    iPhone 5S/GSM+CDMA, N53
 iPhone7,2 ->    iPhone 6, N61
 iPhone7,1 ->    iPhone 6 Plus, N56
 iPhone8,1 ->    iPhone 6S/Samsung, N71
 iPhone8,1 ->    iPhone 6S/TSMC, N71m
 iPhone8,2 ->    iPhone 6S Plus/Samsung, N66
 iPhone8,2 ->    iPhone 6S Plus/TSMC, N66m
 iPhone8,4 ->    iPhone SE/TSMC, N69
 iPhone8,4 ->    iPhone SE/Samsung, N69u
 iPhone9,1 ->    iPhone 7/?, D10
 iPhone9,3 ->    iPhone 7/?, D101
 iPhone9,2 ->    iPhone 7 Plus/?, D11
 iPhone9,4 ->    iPhone 7 Plus/?, D111

 iPod1,1   ->    iPod touch 1, N45
 iPod2,1   ->    iPod touch 2, N72
 iPod2,2   ->    iPod touch 3, Prototype
 iPod3,1   ->    iPod touch 3, N18
 iPod4,1   ->    iPod touch 4, N81
 
 // Thanks NSForge
 ipad0,1   ->    iPad, Prototype
 iPad1,1   ->    iPad 1, WiFi and 3G, K48
 iPad2,1   ->    iPad 2, WiFi, K93
 iPad2,2   ->    iPad 2, GSM 3G, K94
 iPad2,3   ->    iPad 2, CDMA 3G, K95
 iPad2,4   ->    iPad 2, WiFi R2, K93A
 iPad3,1   ->    The new iPad, WiFi
 iPad3,2   ->    The new iPad, CDMA
 iPad3,3   ->    The new iPad
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)

 iProd2,1   ->   AppleTV 2, Prototype
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??

 i386, x86_64 -> iPhone Simulator
*/


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = @(answer);

    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
*/

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return fattributes[NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return fattributes[NSFileSystemFreeSize];
}

+( NSInteger )getSubmodel:( NSString* )platform
{
    NSInteger submodel = -1;
    
    NSArray* components = [ platform componentsSeparatedByString:@"," ];
    if ( [ components count ] >= 2 )
    {
        submodel = [ [ components objectAtIndex:1 ] intValue ];
    }
    return submodel;
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
    return [UIDevice platformTypeForString:[self platform]];
}


- (NSString *) platformString
{
    return [UIDevice platformStringForType:[self platformType]];
}

+ (BOOL)is86PlatformPrefix:(NSString *)platform
{
    return [platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"];
}

+ (BOOL)isSmallerScreenForPlatform:(NSString *)platform
{
    BOOL smallerScreen = YES;
    
    // Simulator thanks Jordan Breeding
    if ( [self is86PlatformPrefix:platform] )
    {
        smallerScreen = [ [UIScreen mainScreen] bounds].size.width < 768;
    }
    
    return smallerScreen;
}

+ (NSUInteger) platformTypeForString:(NSString *)platform
{
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceiPhone1;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceiPhone3G;
    if ([platform hasPrefix:@"iPhone2"])            return UIDeviceiPhone3GS;
    if ([platform isEqualToString:@"iPhone3,1"])    return UIDeviceiPhone4GSM;
    if ([platform isEqualToString:@"iPhone3,2"])    return UIDeviceiPhone4GSMRevA;
    if ([platform isEqualToString:@"iPhone3,3"])    return UIDeviceiPhone4CDMA;
    if ([platform hasPrefix:@"iPhone4"])            return UIDeviceiPhone4S;
    if ([platform isEqualToString:@"iPhone5,1"])    return UIDeviceiPhone5GSM;
    if ([platform isEqualToString:@"iPhone5,2"])    return UIDeviceiPhone5CDMA;
    if ([platform isEqualToString:@"iPhone5,3"])    return UIDeviceiPhone5CGSM;
    if ([platform isEqualToString:@"iPhone5,4"])    return UIDeviceiPhone5CGSMCDMA;
    if ([platform isEqualToString:@"iPhone6,1"])    return UIDeviceiPhone5SGSM;
    if ([platform isEqualToString:@"iPhone6,2"])    return UIDeviceiPhone5SGSMCDMA;
    if ([platform isEqualToString:@"iPhone7,2"])    return UIDeviceiPhone6;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDeviceiPhone6Plus;
    if ([platform isEqualToString:@"iPhone8,1"])    return UIDeviceiPhone6S;
    if ([platform isEqualToString:@"iPhone8,2"])    return UIDeviceiPhone6SPlus;
    if ([platform isEqualToString:@"iPhone8,4"])    return UIDeviceiPhoneSE;
    if ([platform isEqualToString:@"iPhone9,1"])    return UIDeviceiPhone7;
    if ([platform isEqualToString:@"iPhone9,3"])    return UIDeviceiPhone7;
    if ([platform isEqualToString:@"iPhone9,2"])    return UIDeviceiPhone7Plus;
    if ([platform isEqualToString:@"iPhone9,4"])    return UIDeviceiPhone7Plus;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDeviceiPod1;
    if ([platform isEqualToString:@"iPod2,2"])      return UIDeviceiPod3;
    if ([platform hasPrefix:@"iPod2"])              return UIDeviceiPod2;
    if ([platform hasPrefix:@"iPod3"])              return UIDeviceiPod3;
    if ([platform hasPrefix:@"iPod4"])              return UIDeviceiPod4;
    if ([platform hasPrefix:@"iPod5"])              return UIDeviceiPod5;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDeviceiPad1;
    if ([platform hasPrefix:@"iPad2"])
    {
        NSInteger submodel = [ UIDevice getSubmodel:platform ];
        if ( submodel <= 4 )
        {
            return UIDeviceiPad2;
        } else
        {
            return UIDeviceiPadMini;
        }
    }
    if ([platform hasPrefix:@"iPad3"])
    {
        NSInteger submodel = [ UIDevice getSubmodel:platform ];
        if ( submodel <= 3 )
        {
            return UIDeviceTheNewiPad;
        } else
        {
            return UIDeviceiPad4G;
        }
    }
    
    if ([platform isEqualToString:@"iPad4,1"])    return UIDeviceiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])    return UIDeviceiPadAirLTE;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    
    if ( [self is86PlatformPrefix:platform] )
    {
        if ( [self isSmallerScreenForPlatform:platform] )
        {
            return UIDeviceiPhoneSimulatoriPhone;
        } else
        {
            return UIDeviceiPhoneSimulatoriPad;
        }
    }
    
    return UIDeviceUnknown;
}

+ (NSString *) platformStringForType:(NSUInteger)platformType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}

+ (NSString *) platformStringForPlatform:(NSString *)platform
{
    NSUInteger platformType = [UIDevice platformTypeForString:platform];
    return [UIDevice platformStringForType:platformType];
}

+ (BOOL) hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

+ (NSString *) imageSuffixRetinaDisplay
{
    return @"@2x";
}

+ (BOOL) has4InchDisplay
{
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

+ (NSString *) imageSuffix4InchDisplay
{
    return @"-568h";
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    if ( [UIDevice is86PlatformPrefix:platform] )
    {
        if ( [UIDevice isSmallerScreenForPlatform:platform] )
        {
            return UIDeviceFamilyiPhone;
        } else
        {
            return UIDeviceFamilyiPad;
        }
    }
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    // NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", 
    //                       *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return outstring;
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
Class  btclass = NSClassFromString(@"GKBluetoothSupport");
if ([btclass respondsToSelector:@selector(bluetoothStatus)])
{
    printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
    bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
    printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
}
*/
@end
