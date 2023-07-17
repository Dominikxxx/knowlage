# <font color = red size = 6> **CODESYS Runtime (Windows)移植流程** </font>
## <font size = 5> 1. 软件要求 </font>
>    * WDK版本 >> Windows Driver Kir V7.1,新版本的会出现移植问题（支持Win7）
>    * IDE环境 >> VS2010以上都可以
>    * OEM信息 >> %\Configuration\3S_INFO.txt

## <font size = 5> 2. 组件移植 </font>
### 2.1 移植OEM组件

***
   1. 打开 **_"%Platforms\3SRTE3\CmpDriver_Toolkit"_** 工程，修改 **_SysTargetOEM_** 组件需要将其设成启动项目；

   2. 配置编译器附加文件(c/c++),具体如截图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\1.png" width = "350" height = "200" alt="依赖头文件路径" align=center />
</div>

   3. 配置链接器，具体如截图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\2.png" width = "350" height = "150" alt="链接器配置" align=center />
</div>

  4. 重新生成 **_SysTargetOEM_**  组件
  ***

  5. 将系统文件 **_SysTargetOEM.sys_** 和 注册表文件 **_SysTargetOEM.reg_** 拷贝到工控机内，具体链接如下：

           \%Platforms\3SRTE3\CmpDriver_Toolkit\SysTarget_Overwrite\Registration\SysTargetOEM.reg

           \%Platforms\3SRTE3\CmpDriver_Toolkit\SysTarget_Overwrite\Export\SysTargetOEM.sys
  
  6. 将系统文件 **_SysTargetOEM.sys_** 安装到工控机 **_C:\Windows\System32\drivers_** 文件夹内，运行注册表文件 **_SysTargetOEM.reg_**

  7. 打开 **_C\ProgramData\CODESYS\CODESYSControlRTEV3_** 内的设备文件夹，找到 **_CODESYSControl_User.cfg_** 文件

  8.  修改 **_CODESYSControl_User.cfg_** 文件副本，将 **_OverloadableFunctions=1_** <font color="red"> **(大小写敏感)** </font>添加到文件内，在组件内添加 **_SysTargetOEM_**，需要注意的是，<font color="red">__如果有对应的网卡也需要添加，并且组件ID必须从小到大排列，组件ID不能有相同的__</font>;
  修改完成后将其放入原来的 文件夹内，关闭 **_Runtime_** 并重启。下图为修改后的 **_.cfg_** 文件案例：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\3.png" width = "350" alt="cfg文件配置图" align=center />
</div>   

***
  9. 找到RTE安装包<font color="red">__(与开发包版本相同)__</font>里面的 **_.package_** 文件,在软件内进行安装，会安装标准RTE的xml文件，将标准的xml文件导出；

<div style="text-indent:2em;">
  <p>图1：<b><i>package</i></b> 安装包</p>
  <div align="center" style= "margin:30px">
  <img src="\file\组件移植\image\4.png" width = "350"  alt="package图" align=center />
  </div>
  <p>图2：<b><i>xml</i></b> 文件导出</p>
  <div align="center" style= "margin:30px">
  <img src="\file\组件移植\image\5.png" width = "350"  alt="导出xml文件" align=center />
  </div>
</div>

  10. 在开发包 **_Configuration_** 文件夹内，有制作好的 **_xml_** 文件，打开之后复制关于OEM厂商的信息，替换到标准RTE的 **_xml_** 文件内,替换信息如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\6.png" width = "350"  alt="修改的设备信息" align=center />
</div> 

  11. 安装制作好的xml文件，扫描网络，看识别是否正常 <font color="red"><b><i>(设备信息是否正确)</b></i></font> ；

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\7.png" width = "350"  alt="通讯测试" align=center />
</div>  

***

### 2.2 添加外部库

#### 2.2.1 添加外部库自身接口和实现

1.  外部库实际的原理：在IDE中生成.M4文件，通过提供的M4工具生成C语言可以理解的.h头文件，以此实现调用，具体原理如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\8.png" width = "350"  alt="外部库原理图" align=center />
 <p>Tips：<i>如果你依赖了其他组件的内容，使用Dep.h头文件</i></p> 
</div> 

2.  在IDE创建外部库，先创建库工程，编写需要的程序。并将需要外部实现的功能块，属性内的编译方式修改为外部实现。具体如下图：

<div  align="center" style= "margin:30px">    
  <img src="\file\组件移植\image\9.png" width = "350"  alt="属性设置截图" align=center />
</div> 

3.  选择菜单栏中 **_编译_** ➡ **_生成RunTime系统文件_** ➡ **_填写组件名称_**<font color="red"> **(Runtime实际的实现需要和此次设定的名称保持相同)** </font> ➡ **_勾选M4接口文件_** ➡ **_勾选C根文件_**。所有的组件都存放在开发包 **_Templates_** 文件夹内,空组件的名称为 **_CmpTemplateEmpty_** ，输出路径为实际组件生成之后的存放位置。具体如下图：


<div  align="center" style= "margin:30px">

 <img src="\file\组件移植\image\10.png" width = "350"   alt="生成Runtime系统文件选项" align=center />

</div> 
 
<div  align="center" style= "margin:30px" >

 <img src="\file\组件移植\image\11.png" width = "350"   alt="生成Runtime系统文件配置" align=center />
 
</div>


4. 使用SDK中提供的Python程序，创建模板的副本，并修改必要信息，生成定义的组件文件夹<font color="red"> **(文件夹名称和刚才配置的外部库组件名称相同，具体看步骤3)** </font>。调用程序填入对应的参数，**_-t后面的参数为 “ 开发包提供的空的组件模板 ”_**,**_-c后面的参数为 “ 实际需要生成的组件名称 ”_**。空的组件模板的名字：**_CmpTemplateEmpty_**。

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\12.png" width = "350"  alt="python脚本程序运行图" align=center />
</div> 

5. 将生成的模板文件中 **_.cpp_** 、 **_.h_**  删除；

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\13.png" width = "350"  alt="模板文件删除后剩余文件" align=center />
</div> 

6. 将软件生成的 **_.m4_** 放置进组件文件夹，并点击 **_.bat_** 文件重新生成 **_.cpp_** 、 **_.h_** 文件。

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\14.png" width = "350"  alt="创建的基于库m4文件" align=center />
</div> 

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\15.png" width = "350"  alt="完整的组件文件列表" align=center />
</div> 

7. 打开软件生成的 **_.c_** 文件，将其中对应的实现复制，放到组件模板内的  **_.c_** 文件内，并写相应的实现。软件生成的实现函数如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\16.png" width = "350"  alt="软件生成的C文件实现函数" align=center />
</div>

#### 2.2.2 将外部库添加到RunTime内

1. 打开 **_"%Platforms\3SRTE3\CmpDriver_Toolkit"_** 工程，修改 **_CmpTemplate_** 组件需要将其设成启动项目；

2. 同样需要和 **_SysTargetOEM_** 组件一样，设置相应的编程环境，具体流程参考 2.1 节；额外增加的配置选项：需要在 **_C/C++_** 附加包含目录里 **_..\..\..\Templates\CmpTemplate_** 修改为 自定义组件文件夹名；具体如图。

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\17.png" width = "350"  alt="外部库环境配置额外项" align=center />
</div>

3. 将自定义组件内的 **_.c_** 文件，导入到工程中

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\18_1.png" width = "350"  alt="c文件图片" align=center />
</div>

4. 对 **_CmpDriver.c_** 中的引用文件名进行修改，将自定义组件依赖头文件 **_dep.h_** 添加进来，具体如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\18.png" width = "350"  alt="CmpDriver.c文件修改" align=center />
</div>

5. 在 **_CmpDriver.h_** 中，将 **_MY_CMPDRV_NAME_** 修改为自定义组件的名称，具体如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\20.png" width = "350"  alt="CmpDriver.h文件修改" align=center />
</div>

6. 在 **_CmpLibTestDep.h_** <font color="red"> **(及自定义组件依赖头文件)** </font> 中修改组件的ID，需要注意的是，OEM自定义组件，ID号从2000开始，顺序排列，中间不能为空;将 **_%\Configuration\3S_INFO.txt中的VendorID_** 替换到程序中。具体如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\21.png" width = "350"  alt="组件ID号" align=center />
</div>

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\18_3.png" width = "350"  alt="VendorID" align=center />
</div>

7. 右击工程，生成 **_.sys_** 文件.

8. 移植外部库方式参考2.1节。需要注意的是，因为没有对应的注册表文件，需要对原来注册 **_OEMTarget_** 的注册表进行修改，将名字改为自定义组件的名称，如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\22.png" width = "350"  alt="修改注册表" align=center />
</div>

9. 可以通过日志文件判断组件是否正常加载，具体如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\23.png" width = "350"  alt="组件正常运行图" align=center />
</div>

9. 运行PLC，效果如图：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\24.png" width = "350"  alt="外部库正常运行" align=center />
</div>

#### 2.2.3 添加依赖的接口和实现

1. 打开自定义组件文件夹里的 **_dep.m4_** 文件，添加依赖的接口和需要使用的函数。这里以 **_获取系统时间为例_**

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\25.png" width = "350"  alt="依赖库接口的添加" align=center />
</div>

2. 运行 **_bat_** 文件重新生成 **_dep.h_** 文件，添加新的实现 具体方式参考 2.2.1的内容。

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\26.png" width = "350"  alt="实现的代码" align=center />
</div>

3. 重新生成新的 **_sys_** 文件，在Runtime中运行。具体效果如下：

<div  align="center" style= "margin:30px">    
 <img src="\file\组件移植\image\27.png" width = "350"  alt="运行效果" align=center />
</div>


