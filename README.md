# Humble

Humble是c++、lua语言开发的多线程服务器框架,网络底层使用libevent。    
目前支持MQTT、WebSocket、Http等协议。    
服务器间支持RPC调用，任务之间也支持RPC调用。      

## 一、编译Humble     
* windows使用vs2015；  
* linux使用mklib.sh编译依赖库，然后再mk.sh。  

## 二、配置文件  
* config.ini 文件配置服务器启动参数。   

## 三、注册数据解析器    
* 数据解析器继承CParser，将parsePack函数完成，
然后在Humble.cpp中的initParser函数中添加该解析器。 

## 四、简单使用(回显为例)   
* 1、创建echo服务(echo.lua，复制template.lua修改服务名即可)：     
function initTask()--服务初始化      
end    
function runTask()--服务消息处理       
end     
function destroyTask()--服务释放   
end 

* 2、建立监听(start.lua onStart()):     
humble.setParser(1, "tcp1")--设置数据解析    
humble.addListener(1, "0.0.0.0", 15000)--建立监听                 

* 3、注册echo服务(start.lua onStart())     
humble.regTask("echo", 1000)      
--将echo消息通道保存在变量中   
tChan.echo = humble.getChan("echo")      

* 4、将收到的消息发送到echo模块处理(start.lua onTcpRead(......))    
utile.chanSend(tChan.echo, utile.Pack(...))    

* 5、回显逻辑(echo.lua runTask())             
local _,_,_ = utile.unPack(pChan:Recv())--取出消息    
......       
humble.Send(sock, uiSession, buffer)--返回消息   

## 联系我    
279133271@qq.com    
