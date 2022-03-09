#include "ding/common/StringUtil.h"

namespace dan
{

	static char _HexToChar[] =
	{
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
	};

	bool StringUtil::IsHex(const char& ch)
	{
		return (ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F');
	}

	/* ×Ö·û´®Ìæ»»£¬ ²»¸Ä±äÔ­×Ö·û´® */
	std::string StringUtil::Replace(const std::string& str, const std::string& src, const std::string& dst)
	{
		if (src == dst)
			return str;

		std::string out = str;
		size_t pos = str.find(src, 0);
		while (pos != std::string::npos)
		{
			out.replace(pos, src.size(), dst);
			pos = out.find(src, pos + dst.size());
		}

		return out;
	}

	/* ×Ö·ûÌæ»»£¬²»¸Ä±äÔ­×Ö·û´® */
	std::string StringUtil::Replace(const std::string& str, char src, char dst)
	{
		std::string out = str;
		char* buf = &(*out.begin());

		while (*buf)
		{
			if (*buf == src)
				*buf = dst;
			buf++;
		}

		return out;
	}

	/* Çå³ý»»ÐÐ */
	void StringUtil::CleanOut(std::string& str, char src)
	{
		auto it = str.begin();
		while (it != str.end())
		{
			if ((*it) == src)
			{
				it = str.erase(it);
			}
			else
			{
				++it;
			}
		}
	}

	/* ×Ö·û´®Ìæ»»£¬²¢¸Ä±äÔ­×Ö·û´®£¬Èç¹ûÓÐ¶à¸öÖ»Ìæ»»µÚÒ»¸ö */
	bool StringUtil::ReplaceRet(std::string& str, const std::string& src, const std::string& dst)
	{
		if (src == dst)
			return false;

		bool bReplaced = false;
		size_t pos = str.find(src, 0);
		if (pos != str.npos)
		{
			str.replace(pos, src.size(), dst);
			bReplaced = true;
		}

		return bReplaced;
	}

	/* È¥µô×Ö·ûÖÐ×ó»ò¿Õ°×, ¸Ä±äÔ­×Ö·û´® */
	void StringUtil::Trim(std::string& str, bool bLeft, bool bRight)
	{
		static const std::string delims = "\t\r\n ";
		if (bRight)
			str.erase(str.find_last_not_of(delims) + 1);
		if (bLeft)
			str.erase(0, str.find_first_not_of(delims));
	}

	/* ·Ö¸î×Ö·û´®, maxSplits±íÊ¾×î´ó·Ö¸îÊýÁ¿£¬Îª0±íÊ¾ÎÞÏÞÖÆ */
	StringArray StringUtil::Split(const std::string& str, const std::string& delims, Dword maxSplits)
	{
		StringArray ret;
		if (str.empty())
			return ret;

		ret.reserve(maxSplits ? maxSplits + 1 : 10);
		Dword numSplits = 0;

		size_t start, pos;
		start = 0;

		do
		{
			pos = str.find_first_of(delims, start);
			if (pos == start)
			{
				start = pos + 1;
			}
			else if (pos == std::string::npos || (maxSplits && numSplits == maxSplits))
			{
				ret.push_back(str.substr(start));
				break;
			}
			else
			{
				ret.push_back(str.substr(start, pos - start));
				start = pos + 1;
			}

			start = str.find_first_not_of(delims, start);
			++numSplits;

		} while (pos != std::string::npos);

		return ret;
	}

	/*
	* ·Ö¸î×Ö·û´®
	*/
	void StringUtil::Split(const std::string& str, const std::string& delims, StringArray& outArr)
	{
		if (!str.empty())
		{
			size_t start = 0, pos = 0;
			do
			{
				pos = str.find_first_of(delims, start);
				if (pos == start)
				{
					start = pos + 1;
				}
				else if (pos == std::string::npos)
				{
					outArr.push_back(str.substr(start));
					break;
				}
				else
				{
					outArr.push_back(str.substr(start, pos - start));
					start = pos + 1;
				}

				start = str.find_first_not_of(delims, start);
			} while (pos != std::string::npos);
		}
	}

	/* ×ªÐ¡Ð´ */
	void StringUtil::LowerCase(std::string& str)
	{
		std::transform(str.begin(), str.end(), str.begin(), (int(*)(int)) tolower);
	}

	/* ×ª´óÐ´ */
	void StringUtil::UpperCase(std::string& str)
	{
		std::transform(str.begin(), str.end(), str.begin(), (int(*)(int)) toupper);
	}

	/* ¸ñÊ½»¯×Ö·û´® */
	std::string StringUtil::Format(const char* formats, ...)
	{
		char szBuffer[4096];
		va_list args;
		va_start(args, formats);
		vsprintf(szBuffer, formats, args);
		va_end(args);
		return szBuffer;
	}


	bool StringUtil::StartWith(const std::string& str, const std::string& pattern, bool lowCase)
	{
		size_t thisLen = str.length();
		size_t patternLen = pattern.length();
		if (thisLen < patternLen || patternLen == 0)
			return false;

		std::string startOfThis = str.substr(0, patternLen);
		if (lowCase)
			StringUtil::LowerCase(startOfThis);

		return (startOfThis == pattern);
	}

	bool StringUtil::EndWith(const std::string& str, const std::string& pattern)
	{
		size_t thisLen = str.length();
		size_t patternLen = pattern.length();
		if (thisLen < patternLen || patternLen == 0)
			return false;

		std::string endOfThis = str.substr(thisLen - patternLen, patternLen);

		return (endOfThis == pattern);
	}

	/* ±È½Ï×Ö·û´®ÊÇ·ñÏàµÈ */
	bool StringUtil::Equal(const std::string& str1, const std::string& str2, bool bCaseSensitive/*= true*/)
	{
		if (bCaseSensitive)
		{
			return (str1 == str2);
		}
		else
		{
			std::string lstr1 = str1;
			std::string lstr2 = str2;
			LowerCase(lstr1);
			LowerCase(lstr2);
			return (lstr1 == lstr2);
		}
	}

	float StringUtil::ParseFloat(const std::string& val, float defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		float ret = defVal;
		str >> ret;

		return ret;
	}

	double StringUtil::ParseDouble(const std::string& val, double defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		double ret = defVal;
		str >> ret;

		return ret;
	}

	int StringUtil::ParseInt(const std::string& val, int defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		int ret = defVal;
		str >> ret;

		return ret;
	}

	i16 StringUtil::ParseI16(const std::string& val, i16 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		i16 ret = defVal;
		str >> ret;

		return ret;
	}

	i32 StringUtil::ParseI32(const std::string& val, i32 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		i32 ret = defVal;
		str >> ret;

		return ret;
	}

	i64 StringUtil::ParseI64(const std::string& val, i64 defaultValue)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		i64 ret = defaultValue;
		str >> ret;

		return ret;
	}

	i64 StringUtil::ParseHexI64(const std::string& val, i64 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val.c_str());
		i64 ret = defVal;
		str >> std::hex >> ret;

		return ret;
	}

	ui8 StringUtil::ParseUI8(const std::string& val, ui8 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		ui8 ret = defVal;
		str >> ret;

		return ret;
	}

	ui16 StringUtil::ParseUI16(const std::string& val, ui16 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		ui16 ret = defVal;
		str >> ret;

		return ret;
	}

	ui32 StringUtil::ParseUI32(const std::string& val, ui32 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		ui32 ret = defVal;
		str >> ret;

		return ret;
	}

	ui64 StringUtil::ParseUI64(const std::string& val, ui64 defVal)
	{
		// Use istringstream for direct correspondence with to_string
		StringStream str(val);
		ui64 ret = defVal;
		str >> ret;

		return ret;
	}

	bool StringUtil::IsNumber(const std::string& val)
	{
		StringStream str(val);
		float tst;
		str >> tst;
		return !str.fail() && str.eof();
	}

	std::string StringUtil::Hex2Char(Dword val)
	{
		std::string out;
		out.resize(4 * 2 + 1);// one byte - two characters

		char* to = (char*)out.c_str();
		Byte *from = (Byte*)(&val) + 3;

		for (int i = 0; i < 4; ++i)
		{
			*(to++) = _HexToChar[(*from) >> 4];		// 4 high bits.
			*(to++) = _HexToChar[(*from) & 0x0f];	// 4 low bits.

			--from;
		}

		return out;
	}
	unsigned char StringUtil::HexToDecimal(const char& ch)
	{
		switch (ch)
		{
		case '0': return 0x0;
		case '1': return 0x1;
		case '2': return 0x2;
		case '3': return 0x3;
		case '4': return 0x4;
		case '5': return 0x5;
		case '6': return 0x6;
		case '7': return 0x7;
		case '8': return 0x8;
		case '9': return 0x9;
		case 'a':
		case 'A': return 0xA;
		case 'b':
		case 'B': return 0xB;
		case 'c':
		case 'C': return 0xC;
		case 'd':
		case 'D': return 0xD;
		case 'e':
		case 'E': return 0xE;
		case 'f':
		case 'F': return 0xF;
		}
		return 0xF;
	}

	void StringUtil::ParseColor3B(const std::string& text, int offset, unsigned char& r, unsigned char& g, unsigned char& b)
	{
		r = (HexToDecimal(text[offset]) << 4) | HexToDecimal(text[offset + 1]);
		g = (HexToDecimal(text[offset + 2]) << 4) | HexToDecimal(text[offset + 3]);
		b = (HexToDecimal(text[offset + 4]) << 4) | HexToDecimal(text[offset + 5]);

	}

	BYTE StringUtil::toHex(const BYTE &x)
	{
		//return x > 9 ? x - 10 + 'A' : x + '0';
		return  x > 9 ? x + 55 : x + 48;
	}

	BYTE StringUtil::fromHex(const BYTE &x)
	{
		//return isdigit(x) ? x - '0' : x - 'A' + 10;
		unsigned char y;
		if (x >= 'A' && x <= 'Z') y = x - 'A' + 10;
		else if (x >= 'a' && x <= 'z') y = x - 'a' + 10;
		else if (x >= '0' && x <= '9') y = x - '0';
		else assert(0);
		return y;
	}

	std::string StringUtil::URLEncode(const std::string &sIn)
	{
		std::string sOut;
		for (size_t ix = 0; ix < sIn.size(); ix++)
		{
			BYTE buf[4];
			memset(buf, 0, 4);
			if (isalnum((BYTE)sIn[ix]) ||
				(sIn[ix] == '-') ||
				(sIn[ix] == '_') ||
				(sIn[ix] == '.') ||
				(sIn[ix] == '~'))
			{
				buf[0] = sIn[ix];
			}
			//else if ( isspace( (BYTE)sIn[ix] ) ) //Ã²ËÆ°Ñ¿Õ¸ñ±àÂë³É%20»òÕß+¶¼¿ÉÒÔ
			//{
			//    buf[0] = '+';
			//}
			else
			{
				buf[0] = '%';
				buf[1] = toHex((BYTE)sIn[ix] >> 4);
				buf[2] = toHex((BYTE)sIn[ix] % 16);
			}
			sOut += (char *)buf;
		}
		return sOut;
	};

	std::string StringUtil::URLDecode(const std::string &sIn)
	{
		std::string sOut;
		for (size_t ix = 0; ix < sIn.size(); ix++)
		{
			BYTE ch = 0;
			if (sIn[ix] == '%')
			{
				ch = (fromHex(sIn[ix + 1]) << 4);
				ch |= fromHex(sIn[ix + 2]);
				ix += 2;
			}
			else if (sIn[ix] == '+')
			{
				ch = ' ';
			}
			else
			{
				ch = sIn[ix];
			}
			sOut += (char)ch;
		}
		/*
		std::string strTemp = "";
		size_t length = str.length();
		for (size_t i = 0; i < length; i++)
		{
			if (str[i] == '+') strTemp += ' ';
			else if (str[i] == '%')
			{
				assert(i + 2 < length);
				unsigned char high = FromHex((unsigned char)str[++i]);
				unsigned char low = FromHex((unsigned char)str[++i]);
				strTemp += high * 16 + low;
			}
			else strTemp += str[i];
		}*/
		return sOut;
	}
	bool StringUtil::isHasCH(const std::string & str)
	{
		bool has = false;
		for (int i = 0; i < str.length(); ++i)
		{
			if (str[i] >= 0 && str[i] <= 127)
			{
				has = false;
			}
			else
			{
				has = true;
				break;
			}
		}
		return has;
	}
}