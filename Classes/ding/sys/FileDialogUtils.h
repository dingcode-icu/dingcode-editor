#ifndef FileDialogUtils_h
#define FileDialogUtils_h

#include <string>

namespace dan{
class FileDialogUtils {
public:
    static std::string GetSaveFile();
    static std::string GetOpenFile();
};

}
#endif /* FileDialogUtils_h */
