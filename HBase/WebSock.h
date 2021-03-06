
#ifndef H_WEBSOCK_H_
#define H_WEBSOCK_H_

#include "NetParser.h"
#include "Singleton.h"
#include "SHA1.h"

H_BNAMSP

//websocket
class CWebSock : public CParser, public CSingleton<CWebSock>
{
public:
    CWebSock(void);
    ~CWebSock(void);

    int parsePack(struct H_Session *pSession, char *pAllBuf, const size_t &iLens, class CBinary *pBinary);

private:
    H_DISALLOWCOPY(CWebSock);
    int shakeHands(struct H_Session *pSession, char *pAllBuf, const size_t &iLens);
    std::string parseKey(class CBinary *pBinary) const;
    std::string createKey(std::string &strKey);
    std::string createResponse(const std::string &strKey) const;

    int parseHead(struct WebSockFram *pFram, const char *pBuffer, const size_t &iLens);
    char *parseData(struct WebSockFram *pFram, char *pBuffer, const size_t &iLens);
    void createHead(std::string *pBuf, const char &cFin, const char &cCode,
        const size_t &iDataLens);

private:
    size_t m_iEndFlagLens;
    std::string m_strVersion;
    CSHA1 m_objSha1;
};

H_ENAMSP

#endif //H_WEBSOCK_H_
