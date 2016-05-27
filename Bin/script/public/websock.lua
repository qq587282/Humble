--[[
websock
--]]

local websock = {}
local pWBinary = CBinary()

local MsgType = {}
MsgType.CONTINUATION = 0x00
MsgType.TEXT = 0x01
MsgType.BINARY = 0x02
MsgType.CLOSE = 0x08
MsgType.PING = 0x09
MsgType.PONG = 0x0A

local function Response(code, fin, val)
    pWBinary:reSetWrite()
    
    local cType = code | 0x80
    if 0 == fin then
        cType = cType & 0x7F
    end    
    pWBinary:setUint8(cType)
    
    local iLens = #val
    if iLens < 126 then  
        pWBinary:setUint8(iLens)
    elseif iLens <= 0xFFFF then  
        pWBinary:setUint8(126)
        pWBinary:setUint16(iLens)
    else
        pWBinary:setUint8(127)
        pWBinary:setUint64(iLens)
    end
    
    if val then
        pWBinary:setByte(val, iLens)
    end
  
    return pWBinary
end

function websock.parsePack(pBinary)
    local tInfo = {}
    
    tInfo.info = pBinary:getByte(pBinary:getSurpLens())
    pBinary:setW2R()
    tInfo.code = pBinary:getUint8()
    tInfo.fin = pBinary:getUint8()
    
    return tInfo
end

--[[��Ƭ֡
��ʼ֡��FINΪ0��opcode��0����
�м�֡��FINΪ0��opcodeΪ0����
����֡��FINΪ1��opcodeΪ0��--]]
function websock.ContBegin(code, val)
    assert(0 ~= code)
    return Response(code, 0, val)
end

function websock.Cont(val)    
    return Response(MsgType.CONTINUATION, 0, val)
end

function websock.ContEnd(val)
    return Response(MsgType.CONTINUATION, 1, val)
end
--�ı�
function websock.Text(val)
    return Response(MsgType.TEXT, 1, val)
end
--������
function websock.Binary(val)
    return Response(MsgType.BINARY, 1, val)
end
--�ر�
function websock.Close()
    return Response(MsgType.CLOSE, 1)
end
--ping
function websock.Ping()
    return Response(MsgType.PING, 1)
end
--pong
function websock.Pong()
    return Response(MsgType.PONG, 1)
end
--����
function websock.shakeHands(strHost, usPort, strKey)   
    local tInfo = {}
    table.insert(tInfo, "GET / HTTP/1.1\r\n")
    table.insert(tInfo, string.format("Host: %s:%d\r\n", strHost, usPort))
    table.insert(tInfo, "Connection: Upgrade\r\n")
    table.insert(tInfo, "Upgrade: websocket\r\n")
    table.insert(tInfo, "Origin: null\r\n")
    table.insert(tInfo, "Sec-WebSocket-Version: 13\r\n")
    table.insert(tInfo, "User-Agent: Humble\r\n")
    table.insert(tInfo, string.format("Sec-WebSocket-Key: %s\r\n", strKey))
    table.insert(tInfo, "Sec-WebSocket-Extensions: x-webkit-deflate-frame\r\n")
    table.insert(tInfo, "\r\n")
    
    local strMsg = table.concat(tInfo, "")
    pWBinary:reSetWrite()
    pWBinary:setByte(strMsg, #strMsg)
    
    return pWBinary
end

return websock