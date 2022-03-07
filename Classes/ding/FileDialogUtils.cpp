//
//  FileDialogUtils.cpp
//  ImGuiX-desktop
//
//  Created by Mac on 2022/2/23.
//

#include "FileDialogUtils.h"

#include <nfd.h>


std::string FileDialogUtils::GetSaveFile(){

    nfdchar_t *outPath = NULL;
    nfdresult_t result = NFD_SaveDialog( NULL, NULL, &outPath );

    std::string strPath = "";
    if ( result == NFD_OKAY ) {
        puts("Success!");
        puts(outPath);

        strPath = outPath;

        free(outPath);
    }
    else if ( result == NFD_CANCEL ) {
        puts("User pressed cancel.");
    }
    else {
        printf("Error: %s\n", NFD_GetError() );
    }

    return strPath;
};


std::string FileDialogUtils::GetOpenFile(){
    nfdchar_t *outPath = NULL;
    nfdresult_t result = NFD_OpenDialog( NULL, NULL, &outPath );

    std::string strPath = "";
    if ( result == NFD_OKAY ) {
        puts("Success!");
        puts(outPath);

        strPath = outPath;

        free(outPath);
    }
    else if ( result == NFD_CANCEL ) {
        puts("User pressed cancel.");
    }
    else {
        printf("Error: %s\n", NFD_GetError() );
    }

    return strPath;
};