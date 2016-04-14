// link to MSI library 
#pragma comment(lib, "msi.lib") 

// include standard Windows and MSI headers 
#include < windows.h > 
// link to MSI library 
#pragma comment(lib, "msi.lib") 
//#include "fstream.h"
// include standard Windows and MSI headers 
#include < windows.h > 
#include < msi.h > 
#include < msiquery.h > 
// Error codes
#define SH_ERROR_SUCCESS			0
#define SH_ERROR_UNKNOWN			1
#define SH_ERROR_FILE_NOT_FOUND		2
#define SH_ERROR_OPERATION_FAILED	3
#define SH_ERROR_NOT_INITIALIZED	4
#define SH_ERROR_INVALID_PARAM		5

#define INSTALLER_STR_INSTALLDIR		( "INSTALLDIR" )
#define INSTALLER_STR_CUSTOMACTIONDATA	( "CustomActionData" )
DWORD SHMsiGetProperty( MSIHANDLE hMsi, LPTSTR lpszProperty, LPTSTR *lpszBuff )
{
	DWORD dwReturn = SH_ERROR_UNKNOWN;
	DWORD dwMSIRet, dwLength;
	dwLength = 0;	
	dwMSIRet = ERROR_INVALID_PARAMETER;
//	DebugPrint( DBG_MSG_LOW, _T("SHMsiGetProperty: Begin\n"));
	if( hMsi && lpszProperty && lpszBuff )
	{
		dwMSIRet = MsiGetProperty( hMsi, lpszProperty, TEXT(""), &dwLength );
		if( dwMSIRet == ERROR_MORE_DATA )
		{
			if( *lpszBuff )
			{
				free( *lpszBuff );
				*lpszBuff = NULL;
			}
			*lpszBuff = (LPTSTR) calloc( dwLength + 1, sizeof(TCHAR) );
			dwMSIRet = MsiGetProperty( hMsi, lpszProperty, *lpszBuff, &dwLength );
		}
		if( dwMSIRet == ERROR_SUCCESS )
			dwReturn = SH_ERROR_SUCCESS;
	}
	else
		dwReturn = SH_ERROR_INVALID_PARAM;
	
//	DebugPrint( DBG_MSG_LOW, _T("PropertyName: %s , PropertyVal: %s\n"), lpszProperty, *lpszBuff );
	//DebugPrint( DBG_MSG_LOW, _T("SHMsiGetProperty: End: RetVal: %d\n"), dwReturn );
	return dwReturn;
}


DWORD SHMsiSetProperty( MSIHANDLE hMsi, LPTSTR lpszProperty, LPTSTR *lpszBuff,LPTSTR lpszPropertyValue )
{
	DWORD dwReturn = SH_ERROR_UNKNOWN;
	DWORD dwMSIRet, dwLength;
	dwLength = 0;	
	dwMSIRet = ERROR_INVALID_PARAMETER;

	if( hMsi && lpszProperty && lpszBuff )
	{
		dwMSIRet = MsiSetProperty( hMsi, lpszProperty, lpszPropertyValue );
		if( dwMSIRet == ERROR_MORE_DATA )
		{
			if( *lpszBuff )
			{
				free( *lpszBuff );
				*lpszBuff = NULL;
			}
			*lpszBuff = (LPTSTR) calloc( dwLength + 1, sizeof(TCHAR) );
			dwMSIRet = MsiGetProperty( hMsi, lpszProperty, *lpszBuff, &dwLength );
		}
		if( dwMSIRet == ERROR_SUCCESS )
			dwReturn = SH_ERROR_SUCCESS;
	}
	else
		dwReturn = SH_ERROR_INVALID_PARAM;
	
//	DebugPrint( DBG_MSG_LOW, _T("PropertyName: %s , PropertyVal: %s\n"), lpszProperty, *lpszBuff );
//	DebugPrint( DBG_MSG_LOW, _T("SHMsiGetProperty: End: RetVal: %d\n"), dwReturn );
	return dwReturn;
}
// is the name we enter in the Custom Action Wizard 
UINT __stdcall BillTest(MSIHANDLE hMsi)
	

{ 
	
    MessageBox( 
      GetForegroundWindow( ), 
      TEXT("HI"), 
      TEXT("HI"), 
      MB_OK | MB_ICONINFORMATION);

 
    return ERROR_SUCCESS; 
}

