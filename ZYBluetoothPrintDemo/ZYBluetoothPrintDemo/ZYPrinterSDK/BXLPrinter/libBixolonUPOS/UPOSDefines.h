/////////////////////////////////////////////////////////////////////
//
// UPOSDefines.h
//
//   General header file for iOS UPOS Applications.
//
// Modification history
// ------------------------------------------------------------------
// 2015-10-27 initial release                                   sbson
/////////////////////////////////////////////////////////////////////


#if !defined(UPOS_DEFINES)
#define      UPOS_DEFINES


/////////////////////////////////////////////////////////////////////
// OPOS "State" Property Constants
/////////////////////////////////////////////////////////////////////

typedef NS_OPTIONS(NSUInteger, __UPOS_STATES) {
    UPOS_S_CLOSED        = 1,
    UPOS_S_IDLE          = 2,
    UPOS_S_BUSY          = 3,
    UPOS_S_ERROR         = 4
};



/////////////////////////////////////////////////////////////////////
// OPOS "ResultCode" Property Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_RESULT_CODE) {
     UPOS_SUCCESS         =   0,
     UPOS_E_CLOSED        = 101,
     UPOS_E_CLAIMED       = 102,
     UPOS_E_NOTCLAIMED    = 103,
     UPOS_E_NOSERVICE     = 104,
     UPOS_E_DISABLED      = 105,
     UPOS_E_ILLEGAL       = 106,
     UPOS_E_NOHARDWARE    = 107,
     UPOS_E_OFFLINE       = 108,
     UPOS_E_NOEXIST       = 109,
     UPOS_E_EXISTS        = 110,
     UPOS_E_FAILURE       = 111,
     UPOS_E_TIMEOUT       = 112,
     UPOS_E_BUSY          = 113,
     UPOS_E_EXTENDED      = 114,
     UPOS_E_DEPRECATED    = 115, // (added in 1.11)
    
     UPOSERR    = 100, // Base for ResultCode errors.
     UPOSERREXT = 200 // Base for ResultCodeExtendedErrors.

};



/////////////////////////////////////////////////////////////////////
// OPOS "ResultCodeExtended" Property Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_RESULT_CODE_EXTENDED) {
    
    // The following applies to ResetStatistics and UpdateStatistics.
    UPOS_ESTATS_ERROR       = 280,
    UPOS_ESTATS_DEPENDENCY  = 282,
    // The following applies to CompareFirmwareVersion and UpdateFirmware.
    UPOS_EFIRMWARE_BAD_FILE = 281

};
/////////////////////////////////////////////////////////////////////
// OPOS "OpenResult" Property Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_OPEN_RESULT) {
    // The following can be set by the control object.
    //  - Control Object already open.
    UPOS_OR_ALREADYOPEN  = 301,
    //  - The registry does not contain a key for the specified device name.
    UPOS_OR_REGBADNAME   = 302,
    //  - Could not read the device name key's default value, or
    //     could not convert this Prog ID to a valid Class ID.
    UPOS_OR_REGPROGID    = 303,
    //  - Could not create a service object instance, or
    //     could not get its IDispatch interface.
    UPOS_OR_CREATE       = 304,
    //  - The service object does not support one or more of the
    //     method required by its release.
    UPOS_OR_BADIF        = 305,
    //  - The service object returned a failure status from its
    //     open call, but doesn't have a more specific failure code.
    UPOS_OR_FAILEDOPEN   = 306,
    //  - The service object major version number is not 1.
    UPOS_OR_BADVERSION   = 307,
    
    // The following can be returned by the service object if it
    // returns a failure status from its open call.
    //  - Port access required at open, but configured port
    //     is invalid or inaccessible.
    UPOS_ORS_NOPORT      = 401,
    //  - Service Object does not support the specified device.
    UPOS_ORS_NOTSUPPORTED= 402,
    //  - Configuration information error.
    UPOS_ORS_CONFIG      = 403,
    //  - Errors greater than this value are SO-specific.
    UPOS_ORS_SPECIFIC    = 450
    
    
    
};


/////////////////////////////////////////////////////////////////////
// OPOS "BinaryConversion" Property Constants (added in 1.2)
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_BINARY_CONVERSION) {
    UPOS_BC_NONE         = 0,
    UPOS_BC_NIBBLE       = 1,
    UPOS_BC_DECIMAL      = 2
};


/////////////////////////////////////////////////////////////////////
// "CheckHealth" Method: "Level" Parameter Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_CHECK_HEALTH_LEVEL) {
    UPOS_CH_INTERNAL     = 1,
    UPOS_CH_EXTERNAL     = 2,
    UPOS_CH_INTERACTIVE  = 3
};


/////////////////////////////////////////////////////////////////////
// UPOS "CapPowerReporting" Property
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_POWER_REPORTING_LEVEL) {
    UPOS_PR_NONE         = 0,
    UPOS_PR_STANDARD     = 1,
    UPOS_PR_ADVANCED     = 2
};


/////////////////////////////////////////////////////////////////////
// UPOS "PowerState" Property
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_POWER_STATUS) {
    UPOS_PN_DISABLED     = 0,
    UPOS_PN_ENABLED      = 1
};


/////////////////////////////////////////////////////////////////////
// UPOS "PowerNotify" Property
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_POWER_NOTIFY) {
    UPOS_PS_UNKNOWN      = 2000,
    UPOS_PS_ONLINE       = 2001,
    UPOS_PS_OFF          = 2002,
    UPOS_PS_OFFLINE      = 2003,
    UPOS_PS_OFF_OFFLINE  = 2004
};


/////////////////////////////////////////////////////////////////////
// "CompareFirmwareVersion" Method: "Result" Parameter Constants
//   (added in 1.9)
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_COMPARE_FIRMWARE_VERSION) {
    UPOS_CFV_FIRMWARE_OLDER      = 1,
    UPOS_CFV_FIRMWARE_SAME       = 2,
    UPOS_CFV_FIRMWARE_NEWER      = 3,
    UPOS_CFV_FIRMWARE_DIFFERENT  = 4,
    UPOS_CFV_FIRMWARE_UNKNOWN    = 5
};

/////////////////////////////////////////////////////////////////////
// "ErrorEvent" Event: "ErrorLocus" Parameter Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_ERROR_LOCUS) {
    UPOS_EL_OUTPUT       = 1,
    UPOS_EL_INPUT        = 2,
    UPOS_EL_INPUT_DATA   = 3
};

/////////////////////////////////////////////////////////////////////
// "ErrorEvent" Event: "ErrorResponse" Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_ERROR_RESPONSE) {
    UPOS_ER_RETRY        = 11,
    UPOS_ER_CLEAR        = 12,
    UPOS_ER_CONTINUEINPUT= 13
};


/////////////////////////////////////////////////////////////////////
// "statusUpdateEvent" Event: Common "Status" Constants
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __UPOS_STATUS) {
    UPOS_SUE_POWER_ONLINE                    = 2001,
    UPOS_SUE_POWER_OFF                       = 2002,
    UPOS_SUE_POWER_OFFLINE                   = 2003,
    UPOS_SUE_POWER_OFF_OFFLINE               = 2004,
    
    UPOS_SUE_UF_PROGRESS                     = 2100,
    UPOS_SUE_UF_COMPLETE                     = 2200,
    UPOS_SUE_UF_COMPLETE_DEV_NOT_RESTORED    = 2205,
    UPOS_SUE_UF_FAILED_DEV_OK                = 2201,
    UPOS_SUE_UF_FAILED_DEV_UNRECOVERABLE     = 2202,
    UPOS_SUE_UF_FAILED_DEV_NEEDS_FIRMWARE    = 2203,
    UPOS_SUE_UF_FAILED_DEV_UNKNOWN           = 2204 
};


/////////////////////////////////////////////////////////////////////
// InterfaceType
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __INTERFACE_TYPE) {
    _INTERFACETYPE_WIFI           = 1,
    _INTERFACETYPE_ETHERNET       = 2,
    _INTERFACETYPE_BLUETOOTH      = 4,
    _INTERFACETYPE_BLUETOOTH_NON_EXCLUSIVE      = 0x10+_INTERFACETYPE_BLUETOOTH,
    _INTERFACETYPE_BROADCAST      = 8,


};

/////////////////////////////////////////////////////////////////////
// InterfaceType
/////////////////////////////////////////////////////////////////////
typedef NS_OPTIONS(NSUInteger, __SHOW_BLUETOOTH_SETTINGS_OPTIONS) {
    _SHOW_BLUETOOTH_SETTINGS_NEVER         = 0,   //  just return paired device list as array.
    _SHOW_BLUETOOTH_SETTINGS_IF_NO_DEVICE  = 1,   //  if doesn't paired to any device,
                                                  //  return paired device list as array after open device pair menu.
    _SHOW_BLUETOOTH_SETTINGS_ALWAYS        = 2,   //  return paired device list as array after
                                                  //  open device pair menu.
    
};
/////////////////////////////////////////////////////////////////////
// General Constants
/////////////////////////////////////////////////////////////////////
#define  UPOS_FOREVER         -1

#endif                  // !defined(UPOS_DEFINES)
