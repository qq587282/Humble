--[[
C++ȫ�ֺ���
--]]

local serialize = require("serialize")
local string = string
local pWorkerMgr = g_pWorkerMgr
local pNet = g_pNetWorker
local pSender = g_pSender
local pEmail = g_pEmail
local newLuaTask = newLuaTask

local humble = {}

--����
function humble.tcpListen(usSockType, strHost, usPort)
    pNet:tcpListen(usSockType, strHost, usPort)
end
function humble.addTcpLink(usSockType, strHost, usPort)
    pNet:addTcpLink(usSockType, strHost, usPort)
end
function humble.closeSock(sock, uiSession)   
    pNet:closeSock(sock, uiSession)
end
function humble.closeByType(usType)   
    pNet:closeByType(usType)
end
function humble.Send(sock, uiSession, strBuf)
    pSender:Send(sock, uiSession, strBuf, string.len(strBuf))
end
function humble.SendB(sock, uiSession, pBinary)
    pSender:sendB(sock, uiSession, pBinary)
end
--tsock: {{sock,session},...}
function humble.broadCast(tSock, strBuf)
    if 0 == #tSock then
        return
    end
    
    pSender:broadCast(tSock, strBuf, string.len(strBuf))
end
function humble.broadCastB(tSock, pBinary)
    if 0 == #tSock then
        return
    end
    
    pSender:broadCast(tSock, pBinary)
end

--�ʼ�
function humble.sendMail(strMail)
    pEmail:sendMail(strMail)
end

--chanע��
function humble.getSendChan(strChanNam, strTaskNam)
    return pWorkerMgr:getSendChan(strChanNam, strTaskNam)
end
function humble.getRecvChan(strChanNam, strTaskNam)
    return pWorkerMgr:getRecvChan(strChanNam, strTaskNam)
end
function humble.regChan(strChanNam, uiCount)
    pWorkerMgr:regChan(strChanNam, uiCount)
end
function humble.regTask(strNam)
    return pWorkerMgr:regTask(strNam, newLuaTask())
end

return humble
