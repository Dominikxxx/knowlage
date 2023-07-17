# 1 使用IEC语言编程完成通讯(自由协议)
## 1.1 使用 syscom 库
>⚠ Tips：工程必须安装syscom库
### 1.1.1 CODESYS配置
需要使用到的函数如下表：

    SysComOpen        : 打开端口   
    SysComSetSettings : 端口设置   
    SysComWrite       : 输出     
    SysComRead        : 读取
  
SysComOpen运行之后会获得一个句柄，这个句柄会用来对串口进行设置以及读写的操作
创建句柄变量，并进行初始化。并创建 RTS_IEC_Result 变量以此获取错误。创建参数变量用于串口参数的设定。

    hCom: RTS_IEC_HANDLE := RTS_INVALID_HANDLE;//句柄变量
    Result: RTS_IEC_RESULT;//结果
    csComSettings: COM_Settings;//端口设置

将 SysComOpen 函数返回值赋给上一步创建的变量 hcom。sPort 变量需要的数值为端口号，使用的内部变量 SYS_COMPORT1 ，即端口1；
同理端口2为 SYS_COMPORT2。pResult 将获得状态传递给 Result，一次判断是否存在错误。

    hCom := SysComOpen(sPort:= SYS_COMPORT1 , pResult:= ADR(Result));

之后我们需要通过 SysComSetSettings 对端口的参数进行设置，包括波特率校验位等。
在判断 hcom 不为空则可以进行设置。

    IF hCom <> RTS_INVALID_HANDLE THEN
    // Configure the connection
    csComSettings.byParity := SYS_NOPARITY;     //校验位
    csComSettings.byStopBits := SYS_ONESTOPBIT; //停止位
    csComSettings.sPort := SYS_COMPORT1;        //端口号
    csComSettings.ulBaudrate := SYS_BR_9600;    //波特率
    csComSettings.ulBufferSize := 8;            //数据位
    csComSettings.ulTimeout := 10;              //超时
    Result := SysComSetSettings(hCom:= hCom, pSettings:= ADR(csComSettings) , pSettingsEx:= 0);
    END_IF

>⚠  Tips： 使用 syscom 库时数据为只能为8！     

之后就可以正常的进行读写了。需要注意的是 SysComWrite 函数和 SysComRead 函数的返回值都是接收的数据长度，是随着通讯逐渐增加的，而不是最后一秒返回的值。函数的 ulSize
引脚请使用 SIZEOF() 函数获得，避免出现的数据丢失。具体的代码如下。

    //缓存区可以使用字符串、数组变量等，hcom及是上问我们创建的句柄变量，不同的端口得到的句柄变量不相同
    SysComWrite(hCom:= hCom,	pbyBuffer:= ADR(abyWriteData)+dwOffset,	ulSize:= SIZEOF(abyWriteData)-dwOffset,	ulTimeout:= 100,	pResult:= ADR(Result) );
    SysComRead(hCom:= hCom,	pbyBuffer:= ADR(arrayRead),	ulSize:= SIZEOF(arrayRead) ,	ulTimeout:= 100,	pResult:= ADR(Result));

>⚠  Tips：CODESYS软件版本为3.5.19.0以上   
>🔖 [原始工程点此处下载](https://markdown.com.cn)

   
### 1.1.2 测试软件配置

测试软件配置如图:
<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\1.png" width = "350"  alt="测试软件配置界面（自由协议）" align=center />
</div>

### 1.1.3 测试结果

串口打开后可以正常的收到PLC发来的数据：

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\2.png" width = "350"  alt="发送数据（自由协议）" align=center />
</div>

我们发送数据，PLC也可以正常的接收到，并且将接收到的数据再返回回来。：

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\3.png" width = "350"  alt="接收数据（自由协议）" align=center />
</div>

## 1.2 使用 CAA SerialCom 库
>⚠ Tips：工程必须安装 CAA SerialCom 库


### 1.2.1 CODESYS配置

需要使用以下功能块：

    como1 : COM.Open;
    comc1 : COM.Close;
    comw1 : COM.Write;
    comr1 : COM.Read;

需要对串口进行配置，需要创建 COM.PARAMETER 的8位数组：

    (* Settings to communicate with the COM Port *)
    aCom1Params : ARRAY [1..7] OF COM.PARAMETER;

参数配置如下：

    aCom1Params[1].udiParameterId := COM.CAA_Parameter_Constants.udiPort;
    aCom1Params[1].udiValue := 1; //端口号
    aCom1Params[2].udiParameterId := COM.CAA_Parameter_Constants.udiBaudrate;
    aCom1Params[2].udiValue := 9600; //波特率
    aCom1Params[3].udiParameterId := COM.CAA_Parameter_Constants.udiParity;
    aCom1Params[3].udiValue := INT_TO_UDINT(COM.PARITY.NONE); //校验位
    aCom1Params[4].udiParameterId := COM.CAA_Parameter_Constants.udiStopBits;
    aCom1Params[4].udiValue := INT_TO_UDINT(COM.STOPBIT.ONESTOPBIT); //停止位
    aCom1Params[5].udiParameterId := COM.CAA_Parameter_Constants.udiTimeout;
    aCom1Params[5].udiValue := 0; //超时
    aCom1Params[6].udiParameterId := COM.CAA_Parameter_Constants.udiByteSize;
    aCom1Params[6].udiValue := 7; //数据位
    aCom1Params[7].udiParameterId := COM.CAA_Parameter_Constants.udiBinary;
    aCom1Params[7].udiValue := 0; 

>⚠  Tips： 使用 CAA SerialCom 库时数据为7或8！  

打开端口：

    como1(xExecute := TRUE, usiListLength:=SIZEOF(aCom1Params)/SIZEOF(COM.PARAMETER),pParameterList:= ADR(aCom1Params));

读取：

    comr1(xExecute := TRUE,hCom:= como1.hCom, pBuffer:= ADR(sRead), szBuffer:= SIZEOF(sRead));  

写入：

    comw1(xExecute := TRUE,hCom:= como1.hCom,pBuffer:= ADR(sWrite),szSize:= SIZEOF(sWrite)) ;

关闭端口：

    comc1(xExecute := TRUE, hCom:= como1.hCom);


>⚠  Tips：CODESYS软件版本为3.5.19.0以上   
>🔖 [原始工程点此处下载](https://markdown.com.cn)


### 1.2.2 测试软件配置

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\1.png" width = "350"  alt="测试软件配置界面（自由协议）" align=center />
</div>

### 1.2.3 测试结果

测试软件发送的数值，被PLC接收并返回，但因为时两个不同的缓存区，所以多了两个字节：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\modbus\串口\image\4.png" width = "350"  alt="CAA SerialCom（自由协议）" align=center />
</div>




# 2 使用IEC语言编程完成通讯(RTU)
>⚠ Tips：工程必须安装 ModbusFB 库
## 2.1 CODESYS作为主站

### 2.1.1 CODESYS主站配置
需要使用的功能块为：

    //主站实例化
    clientSerial: ModbusFB.ClientSerial;
    //读写配置功能块
    clientRequestReadInputRegisters: ModbusFB.ClientRequestReadInputRegisters;
	clientRequestWriteSingleRegister: ModbusFB.ClientRequestWriteSingleRegister;

主站的配置程序如下：

    clientSerial(
        xConnect:= , 
        xConnected=> , 
        xError=> , 
        eErrorID=> , 
        udiNumMsgSent=> , 
        udiNumMsgReply=> , 
        udiNumMsgExcReply=> , 
        udiNumMsgExcReplyIllFct=> , 
        udiNumMsgExcReplyIllDataAdr=> , 
        udiNumReplyTimeouts=> , 
        udiNumReqNotProcessed=> , 
        udiNumReqParamError=> , 
        udiLastTransactionTime=> , 
        iPort:= SysCom.SYS_COMPORT1, //端口
        dwBaudrate:= SysCom.SYS_BR_115200, //波特率
        byDataBits:= 8, //数据位
        eParity:= SysCom.SYS_EVENPARITY, //奇偶校验 
        eStopBits:= SysCom.SYS_ONESTOPBIT, //停止位
        eDTRcontrol:= , 
        eRTScontrol:= , 
        eRtuAscii:= ModbusFB.RtuAscii.RTU, //模式
        udiLogOptions:= );

读写功能配置如下:

    //读输入寄存器 04功能码
    clientRequestReadInputRegisters(
        xExecute:= , 
        udiTimeOut:= , 
        xDone=> , 
        xBusy=> , 
        xError=> , 
        rClient:= clientSerial, //客户端实例
        uiUnitId:= 1, //从站ID
        udiReplyTimeout:= , 
        uiMaxRetries:= , 
        eErrorID=> , 
        eException=> , 
        uiRetryCnt=> , 
        uiStartItem:= 16 , //起始地址
        uiQuantity:= 3,  //连续偏移
        pData:= ADR(aDataInputRegisters[0]));//指向数据缓存区第一个的地址
    //写单个寄存器  06功能码
    clientRequestWriteSingleRegister(
        xExecute:= , 
        udiTimeOut:= , 
        xDone=> , 
        xBusy=> , 
        xError=> , 
        rClient:= clientSerial, //客户端实例
        uiUnitId:= 1, //从站ID
        udiReplyTimeout:= , 
        uiMaxRetries:= , 
        eErrorID=> , 
        eException=> , 
        uiRetryCnt=> , 
        uiItem:= 3 , //起始地址
        uiValue:=  123 );//数值;

>⚠  Tips：目前还不支持Ascii模式，RTU的数据位一定为8

>⚠  Tips：CODESYS软件版本为3.5.19.0以上 
        
>🔖 [原始工程点此处下载](https://markdown.com.cn)       

### 2.1.2 测试软件配置
<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\modbus\串口\image\9.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 2.1.3 测试结果

使用写入指令，能正确的把数值写入从站：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\modbus\串口\image\8.png" width = "350"  alt="master RTU ST" align=center />
</div>

## 2.2 CODESYS作为从站

需要使用的功能块为：

    serverSerial: ModbusFB.ServerSerial;  
    fcsSupported : ModbusFB.SupportedFcs;//支持的功能（功能码）需要手动设置
    aHoldingRegistersSections : ARRAY [0..1] OF ModbusFB.TableSection；//通道配置，需要注意的是不管是什么功能码使用的都是同一种类型
    tableDefs : ModbusFB.TableDefinitions //配置模型

### 2.2.1 CODESYS从站配置

端口配置如下：

    serverSerial(fcsSupported:=fcsSupported, 
                dataModel:=tableDefs, 
                uiUnitId:=1,//从站号
                iPort:=SysCom.SYS_COMPORT2, //端口号
                dwBaudRate:=SysCom.SYS_BR_115200, //波特率
                byDataBits:=8, //数据位
                eParity:=SysCom.SYS_EVENPARITY, //校验位
                eStopBits:=SysCom.SYS_ONESTOPBIT, //停止位
                eRtuAscii:=ModbusFB.RtuAscii.RTU);

创建缓存区：

    aDiscreteInputsMemory : ARRAY [0..9] OF BOOL;  
    aCoilsMemory1 : ARRAY [0..4] OF BOOL;
    aCoilsMemory2 : ARRAY [0..4] OF BOOL;
    aInputRegistersMemory1 : ARRAY [0..6] OF UINT;  
    aInputRegistersMemory2 : ARRAY [0..2] OF UINT;  
    aHoldingRegistersMemory : ARRAY [0..6] OF UINT;  


通道配置（以保持寄存器为例及功能码03）：

    aHoldingRegistersSections : ARRAY [0..1] OF ModbusFB.TableSection := [
        // "holding registers" 0..6
        (
            uiStart := 0,//起始位置
            uiNumDataItems := 6,//偏移
            pStartAddr := ADR(aHoldingRegistersMemory[0]),//指向缓存区数组第一位
            uiDataItemSize := 16
        ),
        // "holding registers" 7..9
        (
            uiStart := 7,
            uiNumDataItems := 3,
            pStartAddr := ADR(aInputRegistersMemory2[0]),
            uiDataItemSize := 16
        )
    ];

配置模型：

    tableDefs : ModbusFB.TableDefinitions := (
        tableDiscreteInputs := (
            uiNumSections := 1,
            pSections := ADR(aDiscreteInputsSections[0])
        ),
        tableCoils := (
            uiNumSections := 2,
            pSections := ADR(aCoilsSections[0])
        ),
        tableInputRegisters := (
            uiNumSections := 3,
            pSections := ADR(aInputRegistersSections[0])
        ),
        tableHoldingRegisters := (
            uiNumSections := 2,//几个通道，例子里面我们创建了两个保持变量的数组，及为2
            pSections := ADR(aHoldingRegistersSections[0])//指向通道配置数组第一个
        )
    ）；

启动串口从站：

        serverSerial(fcsSupported:=fcsSupported, //支持功能码
        dataModel:=tableDefs, // 数据模型
        uiUnitId:=1, //从站号
        iPort:=SysCom.SYS_COMPORT2, //端口号
        dwBaudRate:=SysCom.SYS_BR_115200, //波特率
        byDataBits:=8, //数据位
        eParity:=SysCom.SYS_EVENPARITY, //校验位
        eStopBits:=SysCom.SYS_ONESTOPBIT,//停止位
        eRtuAscii:=ModbusFB.RtuAscii.RTU);//模式


>⚠  Tips：目前还不支持Ascii模式，RTU的数据位一定为8

>⚠  Tips：CODESYS软件版本为3.5.19.0以上 

>🔖 [原始工程点此处下载](https://markdown.com.cn)

### 2.2.2 测试软件配置
测试软件位Modbus Poll

图一为串口配置界面：

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\5.png" width = "350"  alt="测试软件配置界面（RTU）" align=center />
</div>

图二为通道配置界面：

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\6.png" width = "350"  alt="测试软件配置界面（RTU）" align=center />
</div>


### 2.2.3 测试结果

可以正常的对地址为偏移地址为0的数据进行读取和写入：

<div  align="center" style= "margin:30px">    
 <img src="file_Codesys\总线功能\modbus\串口\image\7.png" width = "350"  alt="测试结果（RTU）" align=center />
</div>