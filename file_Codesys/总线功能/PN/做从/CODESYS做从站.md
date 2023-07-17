# CODESYS  PN 从站设备 设置流程
## 1 CODESYS 侧设置
### 1.1设置控制器PN网卡得IP地址：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\1.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 1.2 按照图建立拓扑图(模块根据实际情况添加)：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\2.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 1.3 Ethernet设备选择PN网卡：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\3.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 1.4 配置从站设备名称：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\4.png" width = "350"  alt="master RTU ST" align=center />
</div>

>⚠ 注意：[不同系统配置需求](https://content.helpme-codesys.com/en/CODESYS%20PROFINET/_pnio_runtime_configuration_device.html)

### 1.6 至此CODESYS端配置完成下载即可，然后根据CODESYS PROFINET Device得版本，导出对应得GSD文件，案例中使用得是4.3.0.0版本，导出得及为4.3.0.0版本：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\5.png" width = "350"  alt="master RTU ST" align=center />
</div>



## 2 西门子 侧设置
### 2.1 安装GSD文件：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\6.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 2.2 在网络视图内添加CODESYS从站设备：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\7.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 2.3 配置设备的以太网地址和设备名称：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\8.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 2.4配置设备插槽（和CODESYS软件内配置相同）：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\9.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 2.5配置完成后请右击设备，选择硬件（完全重建）,重建完成之后下载即可：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\10.png" width = "350"  alt="master RTU ST" align=center />
</div>


## 3测试结果：
### 3.1 CODESYS测正常的日志如下图：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\11.png" width = "350"  alt="master RTU ST" align=center />
</div>

### 3.2 西门子测正常情况如图：

<div  align="center" style= "margin:30px">    
<img src="file_Codesys\总线功能\PN\image\12.png" width = "350"  alt="master RTU ST" align=center />
</div>
