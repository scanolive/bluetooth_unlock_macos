## 纯脚本实现蓝牙解锁Macos



### 主要功能
1. 蓝牙自动解锁
	
	当系统处于锁屏状态检测到指定蓝牙设备可连接时(如手动开启蓝牙或进入可连接范围时),系统自动输入密码解锁(注意: 只有从睡眠或屏保恢复时才能自动解锁)
2. 合盖自动锁屏,开盖自动解锁(不需要的可关闭)

3. 自动锁屏,定时检测指定蓝牙设备是否可连接,若指定蓝牙设备不可连接(如关闭蓝牙或设备不在检测范围)则自动锁屏(默认关闭)

### 使用要求
* 熟练使用终端,懂一点编程开发,有shell基础
*  熟悉Macos系统,对swift和applescript有一点了解

 
### 适用条件
* 只有从睡眠或屏保恢复时才能自动解锁
* 锁定系统有两种,一种是开机登录时 (此时不能解锁)
* 另一种是从睡眠或屏保恢复时要求输入密码时 (此时能解锁)


 
### 其他
* 我的系统用了/usr/bin/caffeinate -s禁止睡眠的,所以不确定此脚本是否会阻止睡眠或睡眠状态是否有效
* 若提示需要类似控制电脑等权限,允许即可,或在偏好设置中的隐私设置中添加相关权限
* 适用系统版本如下,其他版本没做过测试
	*  10.12
	* 10.13
	* 10.14
	* 10.15


### 代码引用及感谢

* lapfelix [BluetoothConnector] (https://github.com/lapfelix/BluetoothConnector)
*  atika [bluesense] (https://github.com/atika/bluesense)

	


### 脚本文件说明
* input_passwd.applescript 
	- 输入密码脚本
	- 需要修改"yourpasswd"为Macos用户密码
	- 若考虑安全可将此文件用脚本编辑器导出为仅运行的不可编辑文件
* check_bluetooth.swift
	- 蓝牙检测脚本,直接运行可检测已配对蓝牙设备,加mac地址参数可检测蓝牙设备可连接性
	- 此文件可编译成二进制文件以提高运行速度,编译命令
	
		```
		swiftc check_bluetooth.swift
		```
* check\_lid_do.sh	
	- 检测开盖合盖并执行锁定或解锁系统的脚本
	- 此脚本有一个CHECK_INTERVAL检测间隔参数可配置,默认2秒  
* bluetooth_unlock.sh
	- 蓝牙解锁主脚本
	- 修改脚本替换'00-00-00-00-00-00'为蓝牙解锁设备的mac地址
	- 若已将input\_passwd.applescript另存为不可编辑文件,需修改INPUT_SCRIPT值为对应文件名
	
### 使用向导
1. 配对用于解锁的蓝牙设备	
2. 用check_bluetooth.swift获取用于解锁设备的Mac地址

	```
	./check_bluetooth.swift
	```
3. 修改bluetooth_unlock.sh脚本里的mac地址  
4. nohup后台运行bluetooth_unlock.sh,若要启用自动锁屏可加-l 参数,停止直接kill进程
	
	```
  	nohup ./bluetooth_unlock.sh -D > /dev/null 2>&1 & 
	```
	注意加&后台运行后不要直接关闭终端要ctrl+D或exit退出终端再关闭,否则后台进程会在关闭终端时关闭

5.  若要启用合盖锁屏和开盖解锁nohup运行check\_lid_do.sh

	```
	nohup ./check_lid_do.sh > /dev/null 2>&1 &	
	```
	注意加&后台运行后不要直接关闭终端要ctrl+D或exit退出终端再关闭,否则后台进程会在关闭终端时关闭
6. 若要方便使用或是加入开机启动,可用Automator创建应用程序(app),添加运行shell脚本,输入代码参考如下:

	```
	nohup /usr/local/bin/bluetooth_unlock/check_lid_do.sh > /dev/null 2>&1 &
	nohup /usr/local/bin/bluetooth_unlock/bluetooth_unlock.sh -D > /dev/null 2>&1 &
	```
	