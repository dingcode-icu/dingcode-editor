#ifndef STRINGUTIL_H__
#define STRINGUTIL_H__

#include "ding/Core.h"


namespace dan
{
	typedef unsigned char BYTE;
	class StringUtil
	{
	private:
		StringUtil(){}
		~StringUtil(){}

	public:
		static std::string			Replace(const std::string& str, const std::string& src, const std::string& dst);
		static std::string			Replace(const std::string& str, char src, char dst);
		static void				CleanOut(std::string& str, char src);
		static bool				ReplaceRet(std::string& str, const std::string& src, const std::string& dst);
		static void				Trim(std::string& str, bool bLeft = true, bool bRight = true);
		static StringArray		Split(const std::string& str, const std::string& delims = ", ", Dword maxSprlits = 0);
		static void				Split(const std::string& str, const std::string& delims, StringArray& outArr);
		static void				LowerCase(std::string& str);
		static void				UpperCase(std::string& str);
		static std::string			Format(const char*format, ...);

		static bool				StartWith(const std::string& str, const std::string& pattern, bool lowCase = false);
		static bool				EndWith(const std::string& str, const std::string& pattern);
		static bool				Equal(const std::string& str1, const std::string& str2, bool bCaseSensitive = true);

		static float			ParseFloat(const std::string& val, float defVal = 0.0f);
		static double			ParseDouble(const std::string& val, double defVal = 0.0);
		static int				ParseInt(const std::string& val, int defVal = 0);
		static i16				ParseI16(const std::string& val, i16 defVal = 0);
		static i32				ParseI32(const std::string& val, i32 defVal = 0);
		static i64				ParseI64(const std::string& val, i64 defVal = 0);
		static i64				ParseHexI64(const std::string& val, i64 defVal = 0);
		static ui8				ParseUI8(const std::string& val, ui8 defVal = 0);
		static ui16				ParseUI16(const std::string& val, ui16 defVal = 0);
		static ui32				ParseUI32(const std::string& val, ui32 defVal = 0);
		static ui64				ParseUI64(const std::string& val, ui64 defVal = 0);

		static bool				IsNumber(const std::string& val);
		static std::string			Hex2Char(Dword val);
		static unsigned char	HexToDecimal(const char& ch);
		static void				ParseColor3B(const std::string& text, int offset, unsigned char& r, unsigned char& g, unsigned char& b);

		static bool				IsHex(const char& ch);

		static BYTE toHex(const BYTE &x);
		static BYTE fromHex(const BYTE &x);
		static std::string URLEncode(const std::string &sIn);
		static std::string URLDecode(const std::string &sIn);
		static bool isHasCH(const std::string &str);
	};

#define IntToString(__INT__) StringUtil::Format("%d", __INT__)
#define Int64ToString(__INT__) StringUtil::Format("%lld", __INT__)
#define FloatToString(__FLOAT__) StringUtil::Format("%f", __FLOAT__)
#define FloatToString2(__FLOAT__) StringUtil::Format("%.2f", __FLOAT__)
#define FloatToString3(__FLOAT__) StringUtil::Format("%.3f", __FLOAT__)
}

#endif // STRINGUTIL_H__
